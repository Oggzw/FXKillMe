require_relative 'Gui.rb'
require 'fox16'
include Fox

FXApp.new do |app|
    ComboBoxExample.new(app)
    app.create
    app.run
end