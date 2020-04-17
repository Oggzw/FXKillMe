
require 'fox16'
require 'clipboard'
#require_relative 'Class_Sync.rb'
include Fox
#temp dirlist
$dirlist = ["C:/Users/Ogg1w/Documents/Arduino", "C:/Users/Ogg1w/Documents/My games"]

class FXAddDialog < FXDialogBox 
   def initialize(owner)
      super(owner, "Test of Dialog Box", :width => 600, :height => 160)
      $dir = ""   
      $subf = 0   
      
      # Bottom buttons
      buttons = FXHorizontalFrame.new(self, LAYOUT_SIDE_BOTTOM|FRAME_NONE|LAYOUT_FILL_X|PACK_UNIFORM_WIDTH, :padLeft => 40, :padRight => 40, :padTop => 20, :padBottom => 20)
      
      FXLabel.new(self, "Add directory:")
      target_dir_textfield = FXTextField.new(self, 96)            
      set_target_dir_btn = FXButton.new(self, "Choose destination", :opts => BUTTON_NORMAL)
      
      set_target_dir_btn.connect(SEL_COMMAND) do
         dialog = FXDirDialog.new(self, "Select")
         if dialog.execute != 0
            target_dir_textfield.text = dialog.directory.gsub("\\", "/")
            $dir = dialog.directory.gsub("\\", "/")
         end
      end
      
      subfolder_choice = FXCheckButton.new(buttons, "Subfolders", nil, FRAME_RAISED|FRAME_THICK|LAYOUT_RIGHT|LAYOUT_CENTER_Y)
      subfolder_choice.connect(SEL_COMMAND) {$subf = subfolder_choice.checkState}
      
      accept = FXButton.new(buttons, "Accept", nil, self, ID_ACCEPT,FRAME_RAISED|FRAME_THICK|LAYOUT_RIGHT|LAYOUT_CENTER_Y)
      FXButton.new(buttons, "Cancel", nil, self, ID_CANCEL,FRAME_RAISED|FRAME_THICK|LAYOUT_RIGHT|LAYOUT_CENTER_Y)
      
      accept.setDefault
      accept.setFocus
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
      $dirlist.each do |s|
         option = FXOption.new(pane, s, :opts => JUSTIFY_HZ_APART|ICON_AFTER_TEXT)
         option.connect(SEL_COMMAND) {$dir = s}
      end
      
      FXOptionMenu.new(contents, pane, (FRAME_RAISED|FRAME_THICK|JUSTIFY_HZ_APART|ICON_AFTER_TEXT|LAYOUT_CENTER_X|LAYOUT_CENTER_Y))
      
      # Accept button
      accept = FXButton.new(buttons, "Accept", nil, self, ID_ACCEPT,FRAME_RAISED|FRAME_THICK|LAYOUT_RIGHT|LAYOUT_CENTER_Y)
      
      # Cancel button
      FXButton.new(buttons, "Cancel", nil, self, ID_CANCEL,FRAME_RAISED|FRAME_THICK|LAYOUT_RIGHT|LAYOUT_CENTER_Y)
      
      accept.setDefault
      accept.setFocus
   end
end





class ComboBoxExample < FXMainWindow
   attr_writer :int
   def initialize(app)
      super(app, "Sync.wtf", :width => 800, :height => 600)
      @frame = FXVerticalFrame.new(self, FRAME_SUNKEN|FRAME_THICK|LAYOUT_FILL)
      @dir_Variable = 0
      @Hash = {}
      @mybigdir
      #@logic = FileObserver.new
      @bigfolder = FXPNGIcon.new(app, File.open("bigfolder.png", "rb").read)
      @folder = FXPNGIcon.new(app, File.open("minifolder.png", "rb").read)
      @fileIcon = FXPNGIcon.new(app, File.open("minidoc.png", "rb").read)
      
      # ------------------------------------------------------------------------------------ #
      menubar = FXMenuBar.new(@frame, LAYOUT_FILL_X)
      filemenu = FXMenuPane.new(@frame)
      FXMenuTitle.new(menubar, "Options", nil, filemenu)
      
      FXMenuCommand.new(filemenu, "Add directory").connect(SEL_COMMAND, method(:onCmdShowDialog)) 
      
      FXMenuCommand.new(filemenu, "Remove directory").connect(SEL_COMMAND, method(:onCmdShowDialogModal))        
      
      #FXMenuCommand.new(filemenu, "Sync").connect(SEL_COMMAND) {@logic.sync} # PUT SYNC PROGRAM IN HERE PLS
      
      @treelist = FXTreeList.new(@frame,:opts => TREELIST_NORMAL|TREELIST_SHOWS_LINES|TREELIST_SHOWS_BOXES|TREELIST_ROOT_BOXES|LAYOUT_FILL)
      
      directories
   end
   
   def directories
      @treelist.clearItems()
      @Hash = {}
      $dirlist.each do |directory|
         if @Hash.include?(@Hash.key(directory)) == false
            @Hash[instance_variable_set("@H" + "#{@dir_Variable}", @treelist.appendItem(nil, directory))] = directory
            @treelist.setItemOpenIcon(@Hash.key(directory), @bigfolder)
            @treelist.setItemClosedIcon(@Hash.key(directory), @bigfolder)
         end
         Dir.chdir("#{directory}")
         wd = Dir.pwd
         if $subf == 0
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
               
               @Hash[instance_variable_set("@H" + "#{@dir_Variable}", @treelist.appendItem(@Hash.key(dir.rpartition("/")[0]), dir.rpartition("/")[-1]))] = dir
            elsif
               @Hash[instance_variable_set("@H" + "#{@dir_Variable}", @treelist.appendItem(@Hash.key(directory), dir))] = dir 
            end 
            @treelist.setItemOpenIcon(@Hash.key(dir), @folder)
            @treelist.setItemClosedIcon(@Hash.key(dir), @folder)
            @dir_Variable = @dir_Variable + 1
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
               puts item
               unless item.nil?
                  FXMenuPane.new(self) do |menu_pane|
                     path = FXMenuCommand.new(menu_pane, "Copy path")
                     puts item
                     path.connect(SEL_COMMAND) { Clipboard.copy("#{item}") }
                     menu_pane.create
                     menu_pane.popup(nil, event.root_x, event.root_y)
                     app.runModalWhileShown(menu_pane)
                  end
               end
            end
         end
      end
   end
   
   def onCmdShowDialog(sender, sel, ptr)
      dialog = FXAddDialog.new(self).execute
      if dialog == 1
         $dirlist << $dir
         directories
      end
      puts $subf
   end
   
   def onCmdShowDialogModal(sender, sel, ptr)
      dialog = FXRemoveDialog.new(self).execute
      if dialog == 1 
         $dirlist.delete($dir)
         directories
      end
   end
   
   
   def create
      super
      if $dirlist.empty? == true
         
         dialog = FXDirDialog.new(self, "Select directory")
         if dialog.execute != 0
            $dirlist << dialog.directory
         end 
      end
      
      show(PLACEMENT_SCREEN)
      
   end
end