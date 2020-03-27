class FileObserver
  def initialize()
    @file_inventory = {}
    @removedFiles = []
    @updatedFiles = []
    @DirList = []
    @threadList = []
    sync
  end
  
  attr_reader :file_inventory
  attr_reader :updatedFiles
  attr_reader :removedFiles
  
  module ClassMethods
    
    def sync()
      getMtime
      validateDir
    end
    private
    def getDir()
      wd = Dir.pwd
      dir = Dir.glob('**/*', base:wd)
      return dir 
    end
    
    def getMtime()
      dir = getDir
      dir.each do |dir|
        temp = File.mtime(dir)
        @file_inventory[dir] = temp
      end
    end
    
    def validateDir()
      t = Thread.new do 
        while true
          sleep 5
          validatedFiles = []
          wd = Dir.pwd 
          temp_dir = getDir
          @file_inventory.each do |dir, value|
            temp = temp_dir.include?(dir)
            if temp == false
              @removedFiles << dir
            elsif temp == true
              if @removedFiles.include?(dir) then @removedFiles.delete(dir) 
              else 
                validatedFiles << dir
              end
            end
          end
          validatedFiles.each do |dir| 
            mtime = File.mtime(dir)
            temp = @file_inventory.has_value?(mtime)
            if temp == false
              @updatedFiles << dir
            elsif temp == true
            end
          end
          
        end
      end
    end
  end
  
  include ClassMethods
end