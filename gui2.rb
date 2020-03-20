#---
# Excerpted from "FXRuby: Create Lean and Mean GUIs with Ruby",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/fxruby for more book information.
#---
require 'fox16'

include Fox
require_relative 'bigfolder.png'

class TreeListExample < FXMainWindow
  def initialize(app)
    super(app, "My Tunes", :width => 400, :height => 200)
    treelist_frame = FXHorizontalFrame.new(self, FRAME_SUNKEN|FRAME_THICK|LAYOUT_FILL)

    treelist = FXTreeList.new(treelist_frame,
      :opts => TREELIST_NORMAL|TREELIST_SHOWS_LINES| \
               TREELIST_SHOWS_BOXES|TREELIST_ROOT_BOXES|LAYOUT_FILL)
    artist_1    = treelist.appendItem(nil, "Dir1")
    treelist.setItemOpenIcon(artist_1, bigfolder.png)
    album_1_2   = treelist.appendItem(artist_1, "Dir1/File.txt")
    track_1_2_3 = treelist.appendItem(album_1_2, "Ghost in this House")
    track_1_2_2 = treelist.prependItem(album_1_2, "Maybe")
    track_1_2_1 = treelist.insertItem(track_1_2_2, album_1_2, "Stay")
    album_1_1   =
      treelist.prependItem(artist_1, "Every Time You Say Goodbye")

    artist_3    = treelist.appendItem(nil, "Chicago")
    album_3_1   = treelist.appendItem(artist_3, "Greatest Hits, Vol. I")
    artist_2    = treelist.insertItem(artist_3, nil, "Billy Joel")
    album_2_1   = treelist.appendItem(artist_2, "Greatest Hits, Vol. I")
    artist_4    = treelist.appendItem(nil, "They Might Be Giants")
    album_4_1   = treelist.appendItem(artist_4, "The Else")


    selected_items = []
    treelist.connect(SEL_SELECTED) do |sender, sel, item|
      selected_items << item unless selected_items.include? item
    end
    treelist.connect(SEL_DESELECTED) do |sender, sel, item|
      selected_items.delete(item)
    end



    treelist.connect(SEL_COMMAND) do |sender, sel, current|
      selected_items = []
      treelist.each { |child| add_selected_items(child, selected_items) }
    end





    treelist.connect(SEL_RIGHTBUTTONRELEASE) do |sender, sel, event|
      unless event.moved?
        item = sender.getItemAt(event.win_x, event.win_y)
        unless item.nil?


          # ...



          FXMenuPane.new(self) do |menu_pane|
            play = FXMenuCommand.new(menu_pane, "Play Song")
            play.connect(SEL_COMMAND) { play_song_for(item) }
            info = FXMenuCommand.new(menu_pane, "Get Info")
            info.connect(SEL_COMMAND) { display_info_for(item) }

            # ...


            menu_pane.create
            menu_pane.popup(nil, event.root_x, event.root_y)
            app.runModalWhileShown(menu_pane)

          end

        end
      end
    end



  end
  
  def play_song_for(item); end
  
  def display_info_for(item); end
  

  def add_selected_items(item, selected_items)
    selected_items << item if item.selected?
    item.each { |child| add_selected_items(child, selected_items) }
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