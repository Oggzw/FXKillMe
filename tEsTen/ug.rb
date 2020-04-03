require 'fox16'

include Fox

class DirListWindow < FXMainWindow

  def initialize(app)
    # Invoke the base class initialize first
    super(app, "Directory List", :opts => DECOR_ALL, :width => 800, :height => 600)

    # Make menu bar
    menubar = FXMenuBar.new(self, LAYOUT_FILL_X)
    filemenu = FXMenuPane.new(self)
    FXMenuCommand.new(filemenu, "&Quit\tCtl-Q", nil, getApp(), FXApp::ID_QUIT)
    FXMenuTitle.new(menubar, "&File", nil, filemenu)
    helpmenu = FXMenuPane.new(self)
    FXMenuCommand.new(helpmenu, "&About FOX...").connect(SEL_COMMAND) {
      FXMessageBox.information(self, MBOX_OK, "About FOX",
        "FOX is a really, really cool C++ library...\n" +
        "and FXRuby is an even cooler GUI for Ruby!")
    }
    FXMenuTitle.new(menubar, "&Help", nil, helpmenu, LAYOUT_RIGHT)

    # Text field at bottom
    text = FXTextField.new(self, 10,
      :opts => LAYOUT_SIDE_BOTTOM|LAYOUT_FILL_X|FRAME_SUNKEN|FRAME_THICK)

    # Make contents
    
    treeItem2 = FXTreeItem.new("C:/Program Files/7-Zip/7z.dll")
    treeItem = FXTreeItem.new("C:/Users/wiggo.stromberg/Desktop/Hangman prog2")
    kek = treeItem2.enabled?
    fuck = treeItem2.above
    puts kek
    puts fuck
    dirlist = FXDirList.new(self,  :opts => (HSCROLLING_OFF|DIRLIST_SHOWFILES|
      TREELIST_SHOWS_LINES|TREELIST_SHOWS_BOXES|FRAME_SUNKEN|FRAME_THICK|
      LAYOUT_FILL_X|LAYOUT_FILL_Y))
    dirlist.setDirectory("C:\\Users\\wiggo.stromberg\\Desktop\\Hangman prog2")
    dirlist.scan
  end

  # Create and show the main window
  def create
    super
    show(PLACEMENT_SCREEN)
  end
end

def run
  # Make application
  application = FXApp.new("DirList", "FoxTest")

  # Make window
  DirListWindow.new(application)

  # Create app
  application.create

  # Run
  application.run
end

run