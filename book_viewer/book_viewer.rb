require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"
require "pry"

get '/' do
  @title = 'The Adventures of Sherlock Holmes'
  @table_of_contents = File.readlines('data/toc.txt')

  erb :home
end

get '/chapter/:number' do
  @table_of_contents = File.readlines('data/toc.txt')
  number = params['number'].to_i

  @title = "Chapter #{number}: #{@table_of_contents[number - 1]}"
  @table_of_contents = File.readlines('data/toc.txt')
  @chapter = File.read("data/chp#{number}.txt")

  erb :chapter
end
