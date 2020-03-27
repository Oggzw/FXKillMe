
require 'fox16'

include Fox

class TreeListExample < FXMainWindow
  def initialize(app)
    super(app, "My Tunes", :width => 400, :height => 200)
    treelist_frame = FXHorizontalFrame.new(self, FRAME_SUNKEN|FRAME_THICK|LAYOUT_FILL)

    bigfolder = FXPNGIcon.new(app, File.open("minifolder.png", "rb").read)
    fileIcon = FXPNGIcon.new(app, File.open("minidoc.png", "rb").read)




    treelist = FXTreeList.new(treelist_frame,
      :opts => TREELIST_NORMAL|TREELIST_SHOWS_LINES| \
               TREELIST_SHOWS_BOXES|TREELIST_ROOT_BOXES|LAYOUT_FILL)






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

   
   
    dir_is_file = dir.map { |file| [file.count("/"), file] }  # KEK


    dir = dir.map { |file| [file.count("/"), file] }


    

    i = 0 # amount of / : or the count of children from base folder.
    
    dir_is_dir.each do |dir|
      dir = dir.gsub(" ", "_")
      





    end


    



   


    dir.each do |count, dir|
      dir = dir.gsub(" ", "_")
      

      if i == 0
        if File.directory?(dir) == true
         # instance_variable_set('@'+dir.gsub(" ", "_"), treelist.prependItem(nil, dir))
         # treelist.setItemClosedIcon(@dir, bigfolder)
         # treelist.setItemOpenIcon(@dir, bigfolder)

        elsif File.file?(dir) == true
          #treelist.appendItem(nil,dir)
        end
      end
      if i == 1
        if File.directory?(dir) == true

        elsif File.file?(dir) == true
          temp = dir.partition("/")[i-1]
          puts temp
          
          treelist.appendItem(@icons, dir, oi = fileIcon,ci = fileIcon)

        end
      end
      i = count
    end

    #artist_1    = treelist.appendItem(nil, "Dir1")
    #album_1_1   = treelist.prependItem(artist_1, "Every Time You Say Goodbye")
    #album_1_2   = treelist.appendItem(artist_1, "Dir1/File.txt")
    #track_1_2_1 = treelist.insertItem(track_1_2_2, album_1_2, "Stay")
    #track_1_2_2 = treelist.prependItem(album_1_2, "Maybe")
    #track_1_2_3 = treelist.appendItem(album_1_2, "Ghost in this House")
    #
    #
    #artist_2    = treelist.insertItem(artist_3, nil, "Billy Joel")
    #album_2_1   = treelist.appendItem(artist_2, "Greatest Hits, Vol. I")
    #
    #
    #artist_3    = treelist.appendItem(nil, "Chicago")
    #album_3_1   = treelist.appendItem(artist_3, "Greatest Hits, Vol. I")
    #
    #
    #artist_4    = treelist.appendItem(nil, "They Might Be Giants")
    #album_4_1   = treelist.appendItem(artist_4, "The Else")
    #
    #
    #
    #
    #treelist.setItemOpenIcon(track_1_2_3, fileIcon)
    #treelist.setItemClosedIcon(track_1_2_3, fileIcon)
    #treelist.setItemClosedIcon(artist_1, bigfolder)
    #treelist.setItemOpenIcon(artist_1, bigfolder)
    #
    
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