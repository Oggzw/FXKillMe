class FileObserver
  require 'yaml'
  require_relative 'Gui'
  
  
  def initialize()
    @updatedMtime = {}
    @temp_dirlist = {}
    @removedDirectory = []
    
    sync
  end
  
  
  #  { font_size: 10, font_family: "Arial" }
  # directories = { "C:/Users/wiggo.stromberg/Desktop": [0, mtime] }
  # The key is the directory while the value is an array with first a number of 0 or 1 which decides if subfolders should be counted in Gui.rb 
  # and the mtime is just the mtime of the directory. 
  #
  #startDir = Dir.home + "/Desktop"
  
  
  
  
  module ClassMethods
    
    def sync()
      getMtime
      validateDir
    end
    
    def getDir()
      return $dirlist.keys
    end
    
    def getMtime()
      dir = getDir
      dir.each do |dir|
        mtime = File.mtime(dir)
        #print $dirlist[dir]
        @updatedMtime[dir] = mtime # { "C:/Users/wiggo.stromberg/Desktop": [0, mtime] }
      end
    end
    
    def validateDir()
      thread = Thread.new do 
        while true
          validatedDirectory = []
          updatedFiles = []
          removedDirectory = []
          sleep 5
          
          $dirlist.keys.each do |directory|
            validation = @temp_dirlist.include?(directory)
            if Dir.exist?(directory) == false 
              removedDirectory << directory
            elsif 
              validatedDirectory << directory
            end
          end
          validatedDirectory.each do |directory| 
            
            if  $dirlist.values_at(directory)[1] == @updatedMtime.values_at(directory)
              updatedFiles << directory 
            end
            system "cls"
            puts @updatedMtime.values_at(directory)
         

            puts "-----------------------------------------------"
            puts "These folders have been removed/moved since last sync."
            puts removedDirectory
            puts "-----------------------------------------------"
            puts "These folders have been changed since last sync."
            puts updatedFiles
            puts "-----------------------------------------------"
        
         
            
          end 
        end
      end
    end
  end
  include ClassMethods
end