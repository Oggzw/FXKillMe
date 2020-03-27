require 'fox16'
require_relative 'Class_Sync.rb'
include Fox

class ComboBoxExample < FXMainWindow
    
    def initialize(app)
        super(app, "Sync.wtf", :width => 800, :height => 600)
        
        v_frame = FXVerticalFrame.new( self, :opts => LAYOUT_FILL )
        h_frame = FXHorizontalFrame.new(v_frame, :padding => 0 )
        matrix = FXMatrix.new( h_frame, 3, MATRIX_BY_COLUMNS|LAYOUT_FILL )
        @mybigdir
        @logic = FileObserver.new
        # ------------------------------------------------------------------------------------ #
        menubar = FXMenuBar.new(matrix, LAYOUT_FILL_X)
        filemenu = FXMenuPane.new(matrix)
        FXMenuCommand.new(filemenu, "Add directory").connect(SEL_COMMAND) {
            dialog = FXDirDialog.new(self, "Select")
            if dialog.execute != 0
                @mybigdir = dialog.directory 
                sleep 5
                puts @mybigdir
            end
        }
        
        FXMenuCommand.new(filemenu, "Remove directory").connect(SEL_COMMAND) {puts "DICKCKCKCK"}  # addd removal of directories 
        FXMenuCommand.new(filemenu, "Sync").connect(SEL_COMMAND) {logic.sync} # PUT SYNC PROGRAM IN HERE PLS



        FXMenuTitle.new(menubar, "Options", nil, filemenu)
        helpmenu = FXMenuPane.new(matrix)        
        listview_frame = FXHorizontalFrame.new(v_frame, :opts => FRAME_SUNKEN|FRAME_THICK|LAYOUT_FILL|LAYOUT_TOP, :padding => 0)


        @table = FXTable.new(listview_frame, :opts => LAYOUT_FILL)
        @table.tableStyle |= TABLE_COL_SIZABLE

        @table.rowHeaderWidth = 0
        @table.columnHeaderMode = LAYOUT_FIX_HEIGHT
        @table.columnHeaderHeight = 0
        a = 1


        wd = Dir.pwd
        dir = Dir.glob('**/*', base:wd)

        c = dir.length 

        
        @table.setTableSize(c + 1, 3)
        @table.setItemText(0,0, "Contents of Keylocker folder")
        @table.setItemText(0,2, "Mtime")
        @table.setItemJustify(0,  2, FXTableItem::CENTER_X|FXTableItem::CENTER_Y)
        @table.setItemJustify(0, 0, FXTableItem::CENTER_X|FXTableItem::CENTER_Y)
        
        dir.each do |dir,|
            temp = File.mtime(dir)
            @table.setItemText(a, 0, "#{wd}/#{dir}")
            @table.setItemJustify(a, 0, FXTableItem::LEFT)
            @table.setItemText(a, 2 , "#{temp}")
            @table.setColumnWidth(2, 145)
            @table.setItemText(a, 1, "              ")
            a += 1

            
        end
    end
    
    def create
        super
        show(PLACEMENT_SCREEN)
        @table.fitColumnsToContents( 0 )
        @table.fitColumnsToContents( 2 )
    end
end

if __FILE__ == $0
    FXApp.new do |app|
        ComboBoxExample.new(app)
        app.create
        app.run
    end
end

while true
    puts @logic.removedFiles
    
end