
require 'fox16'

include Fox

class TreeListExample < FXMainWindow
  def initialize(app)
    super(app, "My Tunes", :width => 400, :height => 200)
    
    bigfolder = FXPNGIcon.new(app, File.open("minifolder.png", "rb").read)
    fileIcon = FXPNGIcon.new(app, File.open("minidoc.png", "rb").read)
    
    
    treelist_frame = FXHorizontalFrame.new(self, FRAME_SUNKEN|FRAME_THICK|LAYOUT_FILL)
    
   
    menubar = FXMenuBar.new(treelist_frame, LAYOUT_FILL_Y)
    filemenu = FXMenuPane.new(treelist_frame)
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
    helpmenu = FXMenuPane.new(treelist_frame)        
    
    
    treelist = FXTreeList.new(treelist_frame,
      :opts => TREELIST_NORMAL|TREELIST_SHOWS_LINES| \
      TREELIST_SHOWS_BOXES|TREELIST_ROOT_BOXES|LAYOUT_FILL)
      
      
      
      
      
      
      
    end
    
    def create
      super
      show(PLACEMENT_SCREEN)
    end
  end
  
  if __FILE__ == $0
    FXApp.new do |app|
      TreeListExample.new(app)
      app.create
      app.run
    end
  end