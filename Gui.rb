require 'fox16'
require 'clipboard' 
require 'yaml' 
include Fox
class FXAddDialog < FXDialogBox 
   def initialize(owner)
      super(owner, "Test of Dialog Box", :width => 600, :height => 160)
      $dir = ""   
      $subf = 0   
      
      # Bottom buttons
      buttons = FXHorizontalFrame.new(self, LAYOUT_SIDE_BOTTOM|FRAME_NONE|LAYOUT_FILL_X|PACK_UNIFORM_WIDTH, :padLeft => 40, :padRight => 40, :padTop => 20, :padBottom => 20)
      
      FXLabel.new(self, "Add directory:")
      $target_dir = FXTextField.new(self, 96)            
      set_target_dir_btn = FXButton.new(self, "Choose destination", :opts => BUTTON_NORMAL)
      
      set_target_dir_btn.connect(SEL_COMMAND) do
         dialog = FXDirDialog.new(self, "Select")
         if dialog.execute != 0
            $target_dir.text = dialog.directory.gsub("\\", "/")
         end
      end
      
      subfolder_choice = FXCheckButton.new(buttons, "Subfolders", nil, FRAME_RAISED|FRAME_THICK|LAYOUT_RIGHT|LAYOUT_CENTER_Y)
      subfolder_choice.connect(SEL_COMMAND) {$subf = subfolder_choice.checkState}
      
      accept = FXButton.new(buttons, "Accept", nil, self, ID_ACCEPT,FRAME_RAISED|FRAME_THICK|LAYOUT_RIGHT|LAYOUT_CENTER_Y)
      FXButton.new(buttons, "Cancel", nil, self, ID_CANCEL,FRAME_RAISED|FRAME_THICK|LAYOUT_RIGHT|LAYOUT_CENTER_Y)
      
   end
end

class FXRemoveDialog < FXDialogBox 
   def initialize(owner)
      super(owner, "Test of Dialog Box", DECOR_TITLE|DECOR_BORDER)
      $dir = ""      
      # Bottom buttons
      buttons = FXHorizontalFrame.new(self, LAYOUT_SIDE_BOTTOM|FRAME_NONE|LAYOUT_FILL_X|PACK_UNIFORM_WIDTH, :padLeft => 40, :padRight => 40, :padTop => 20, :padBottom => 20)
      
      # Separator
      FXHorizontalSeparator.new(self,LAYOUT_SIDE_BOTTOM|LAYOUT_FILL_X|SEPARATOR_GROOVE)
      
      # Contents
      contents = FXHorizontalFrame.new(self,LAYOUT_SIDE_TOP|FRAME_NONE|LAYOUT_FILL_X|LAYOUT_FILL_Y|PACK_UNIFORM_WIDTH)
      
      # Directory list
      pane = FXPopup.new(self)
      
      $dirlist.keys.each do |s|
         s = "#{s}" 
         
         option = FXOption.new(pane, s, :opts => JUSTIFY_HZ_APART|ICON_AFTER_TEXT)
         option.connect(SEL_COMMAND) {$dir = s}
      end
      
      FXOptionMenu.new(contents, pane, (FRAME_RAISED|FRAME_THICK|JUSTIFY_HZ_APART|ICON_AFTER_TEXT|LAYOUT_CENTER_X|LAYOUT_CENTER_Y))
      
      # Accept button
      accept = FXButton.new(buttons, "Accept", nil, self, ID_ACCEPT,FRAME_RAISED|FRAME_THICK|LAYOUT_RIGHT|LAYOUT_CENTER_Y)
      
      # Cancel button
      FXButton.new(buttons, "Cancel", nil, self, ID_CANCEL,FRAME_RAISED|FRAME_THICK|LAYOUT_RIGHT|LAYOUT_CENTER_Y)
   end
end

class ComboBoxExample < FXMainWindow
   attr_writer :int
   def initialize(app)
      super(app, "Sync.wtf", :width => 800, :height => 600)
      @frame = FXVerticalFrame.new(self, FRAME_SUNKEN|FRAME_THICK|LAYOUT_FILL)

      @fxItem_Variable = 0
      @Hash = {}

      @bigfolder = FXPNGIcon.new(app, File.open("bigfolder.png", "rb").read)
      @folder = FXPNGIcon.new(app, File.open("minifolder.png", "rb").read)
      @fileIcon = FXPNGIcon.new(app, File.open("minidoc.png", "rb").read)
      
      # ------------------------------------------------------------------------------------ #
      menubar = FXMenuBar.new(@frame, LAYOUT_FILL_X)
      filemenu = FXMenuPane.new(@frame)
      FXMenuTitle.new(menubar, "Options", nil, filemenu)
      
      FXMenuCommand.new(filemenu, "Add directory").connect(SEL_COMMAND, method(:AddDialog)) 
      
      FXMenuCommand.new(filemenu, "Remove directory").connect(SEL_COMMAND, method(:DeleteDialog))        
     
      #FXMenuCommand.new(filemenu, "Sync").connect(SEL_COMMAND) {@logic.sync} # PUT SYNC PROGRAM IN HERE PLS //DRIVE UGH
      
      @treelist = FXTreeList.new(@frame,:opts => TREELIST_NORMAL|TREELIST_SHOWS_LINES|TREELIST_SHOWS_BOXES|TREELIST_ROOT_BOXES|LAYOUT_FILL)
      Thread.new do
         while true
            sleep 30
            directories
         end
      end
      directories
   end
   
   # Internal: Creates the main treelist gui for the program. 
   # Goes through each directory and makes variables for folders so files/folders and be put under them with treelist.AppendItem 
   # Also has support for right click and choice of subfolder or not. 
   #
   #
   # $dirlist - Global array used to store the directories in Class_Sync and Gui
   # Hash - A Hash holding all the Instance variables made to store information about folders FXItem location. 
   #
   def directories
      $dirlist = YAML.load(File.read("Data.yml"))
      begin
         file = File.open("Data.yml", "w")
         file.write($dirlist.to_yaml) 
         puts "hhaahha"
      rescue IOError => e
         puts "some error occured, dir not writable perhaps."
      ensure
         file.close unless file.nil?
      end
      puts YAML.load(File.read("Data.yml"))
      @treelist.clearItems()
      @Hash = {}

      $dirlist.keys.each do |directory|
         directory = "#{directory}"
         if @Hash.include?(@Hash.key(directory)) == false
            @Hash[instance_variable_set("@H" + "#{@fxItem_Variable}", @treelist.appendItem(nil, directory))] = directory

            @treelist.setItemOpenIcon(@Hash.key(directory), @bigfolder)
            @treelist.setItemClosedIcon(@Hash.key(directory), @bigfolder)
         end
         directory = directory.gsub("\\", "/")
         Dir.chdir("#{directory}")
         wd = Dir.pwd

         subf = $dirlist.fetch_values(directory)[0]
         if subf[0] == 0
            temp_dir = Dir.glob('**', base:wd)
         else
            temp_dir = Dir.glob('**/*', base:wd)
         end   
         
         dir_is_dir = []
         dir_is_file = []
         temp_dir.each do |dir|
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
               
               @Hash[instance_variable_set("@H" + "#{@fxItem_Variable}", @treelist.appendItem(@Hash.key(dir.rpartition("/")[0]), dir.rpartition("/")[-1]))] = dir
            elsif
               @Hash[instance_variable_set("@H" + "#{@fxItem_Variable}", @treelist.appendItem(@Hash.key(directory), dir))] = dir 
            end 
            @treelist.setItemOpenIcon(@Hash.key(dir), @folder)
            @treelist.setItemClosedIcon(@Hash.key(dir), @folder)
            @fxItem_Variable = @fxItem_Variable + 1
         end
         dir_is_file.each do | dir |
            if dir.include?("/") == true
               @treelist.appendItem(@Hash.key(dir.rpartition("/")[0]), dir.rpartition("/")[-1], oi = @fileIcon,ci = @fileIcon)
               
            elsif
               @treelist.appendItem(@Hash.key(directory), dir.rpartition("/")[-1], oi = @fileIcon,ci = @fileIcon)
            end
         end

         @treelist.connect(SEL_RIGHTBUTTONRELEASE) do |sender, sel, event|
            unless event.moved?
               item = sender.getItemAt(event.win_x, event.win_y)
               unless item.nil?
                  FXMenuPane.new(self) do |menu_pane|
                     path = FXMenuCommand.new(menu_pane, "Copy path")
                     refresh = FXMenuCommand.new(menu_pane, "refresh")
                     path.connect(SEL_COMMAND) { Clipboard.copy("#{item}") }
                     refresh.connect(SEL_COMMAND) { directories }
                     menu_pane.create
                     menu_pane.popup(nil, event.root_x, event.root_y)
                     app.runModalWhileShown(menu_pane)
                  end
               end
            end
         end
      end
   end

   # Internal: Opens a dialog box to select a directory to add. 
   # The gui also allows for choice of subfolders or not. 
   # modifiedDir - A temporary variable to modify so backslash change to forwardslash. 
   # tempMtime - Checks the Modified time for the directory. 
   #
   # Adds the directory with mtime and subfolder check to $dirlist.
   #
   # Runs the directories method.
   def AddDialog(sender, sel, ptr)
      dialog = FXAddDialog.new(self).execute
      if dialog == 1
         modifiedDir = "#{$target_dir}"
         tempMtime = File.mtime("#{$target_dir}")
         $dirlist[modifiedDir.gsub("\\", "/")] = [$subf, tempMtime]
         directories
      end
   end
   # Internal: Opens a dialog box to select a directory to remove.
   #
   # $dir - Directory selected from table in dialog box. 
   # 
   # Runs the directories method.
   def DeleteDialog(sender, sel, ptr)
      dialog = FXRemoveDialog.new(self).execute
      if dialog == 1 
         $dirlist.delete($dir)
         directories
      end
   end
   #Internal: Creates the gui and Shows it on the screen. 
   #
   #
   #Show - A command from FXruby that shows the gui on the screen. Can have different arguments for how the gui should be shown. 
   #
   def create
      super
      show(PLACEMENT_SCREEN)
   end
end