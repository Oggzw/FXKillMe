require 'yaml'
require 'fox16'
include Fox

$dirlist = YAML.load(File.read("Data.yml"))

if $dirlist == false
    startDir = Dir.home + "/Desktop"
    $dirlist = Hash.new  
    $dirlist[startDir] = [0,"#{File.mtime(startDir)}"]
    puts "wtytfff"
end

require_relative 'Class_Sync.rb'
require_relative 'Gui.rb'

FileObserver.new

FXApp.new do |app|
    ComboBoxExample.new(app)
    app.create
    app.run
end
