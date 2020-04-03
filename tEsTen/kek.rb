require 'fox16'

include Fox

class ComboBoxExample < FXMainWindow
    
    def initialize(app)
        super(app, "Google Classroom Assignment Downloader", :width => 800, :height => 400)
        
        v_frame = FXVerticalFrame.new( self, :opts => LAYOUT_FILL )
        h_frame = FXHorizontalFrame.new(v_frame, :padding => 0 )
        matrix = FXMatrix.new( h_frame, 3, MATRIX_BY_COLUMNS|LAYOUT_FILL )

        
     
    end
    
    def create
        super
        show(PLACEMENT_SCREEN)


    end
end

if __FILE__ == $0
    FXApp.new do |app|
        ComboBoxExample.new(app)
        app.create
        app.run
    end
end