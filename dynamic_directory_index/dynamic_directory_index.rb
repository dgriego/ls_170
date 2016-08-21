require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"
require "pry"

get "/" do
  @files = Dir.glob('public/*').map do |file|
    File.basename(file)
  end.sort

  @files.reverse! if params['sort'] == 'desc'

  erb :file_list
end