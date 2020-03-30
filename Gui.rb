require 'fox16'
require_relative 'Class_Sync.rb'
include Fox

class ComboBoxExample < FXMainWindow
    
    def initialize(app)
        super(app, "Sync.wtf", :width => 800, :height => 600)
        threadCreation = 0 
        @Hash = {}
        frame = FXVerticalFrame.new(self, FRAME_SUNKEN|FRAME_THICK|LAYOUT_FILL)
        @mybigdir
        @logic = FileObserver.new
        # ------------------------------------------------------------------------------------ #
        menubar = FXMenuBar.new(frame, LAYOUT_FILL_X)
        filemenu = FXMenuPane.new(frame)
        FXMenuCommand.new(filemenu, "Add directory").connect(SEL_COMMAND) {
            dialog = FXDirDialog.new(self, "Select")
            if dialog.execute != 0
              @mybigdir = dialog.directory 
              sleep 5
              puts @mybigdir
            end
          }
          
          FXMenuCommand.new(filemenu, "Remove directory").connect(SEL_COMMAND) {puts "DICKCKCKCK"}  # add removal of directories 
          FXMenuCommand.new(filemenu, "Sync").connect(SEL_COMMAND) {@logic.sync} # PUT SYNC PROGRAM IN HERE PLS
          
        FXMenuTitle.new(menubar, "Options", nil, filemenu)
        
        treelist = FXTreeList.new(frame,
            :opts => TREELIST_NORMAL|TREELIST_SHOWS_LINES| \
            TREELIST_SHOWS_BOXES|TREELIST_ROOT_BOXES|LAYOUT_FILL)
            
            
            bigfolder = FXPNGIcon.new(app, File.open("minifolder.png", "rb").read)
            fileIcon = FXPNGIcon.new(app, File.open("minidoc.png", "rb").read)
            
            wd = Dir.pwd
            dir = Dir.glob('**/*', base:wd)
            dir_is_dir = []
            dir_is_file = []
            dir.each do |dir|
                if File.directory?(dir) == true
                    dir_is_dir << dir
                    
                end
                if File.file?(dir) == true
                    dir_is_file << dir
                end
            end
            
            dir_is_dir.each do | dir |
                if dir.include?("/") == true
                    
                    #One-liner kek> Skapar en ny key i hash @Hash med värdet av directory. Denna key innehåller en instance variable set som ökar
                    #Denna variable innehåller ett treelistItem. Den första partition gör så att den hamnar i rätt instance variable som skapas under i
                    #som skapas under i elsif.
                    
                    @Hash[instance_variable_set("@H" + "#{threadCreation}", treelist.appendItem(@Hash.key(dir.rpartition("/")[0]), dir.rpartition("/")[-1]))] = dir
                elsif
                    @Hash[instance_variable_set("@H" + "#{threadCreation}", treelist.appendItem(nil, dir))] = dir 
                    
                end 
                treelist.setItemOpenIcon(@Hash.key(dir), bigfolder)
                treelist.setItemClosedIcon(@Hash.key(dir), bigfolder)
                threadCreation = threadCreation + 1
            end
            dir_is_file.each do | dir |
                if dir.include?("/") == true
                    treelist.appendItem(@Hash.key(dir.rpartition("/")[0]), dir.rpartition("/")[-1], oi = fileIcon,ci = fileIcon)
                elsif
                    treelist.appendItem(nil, dir.rpartition("/")[-1], oi = fileIcon,ci = fileIcon)
                end
            end
            
        end
        
        def create
            super
            show(PLACEMENT_SCREEN)
        end
    end