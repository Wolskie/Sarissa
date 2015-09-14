require 'json'
require 'yaml'
require 'sinatra'

set :root, File.join(File.dirname(__FILE__), "app")
set :public_folder, File.join(File.dirname(__FILE__), "public")


require_relative 'lib/settings'
require_relative 'app/helpers/init'
require_relative 'app/routes/init'

