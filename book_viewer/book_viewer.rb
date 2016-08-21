require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

before do
  @table_of_contents = File.readlines("data/toc.txt")
end

get '/' do
  @title = 'The Adventures of Sherlock Holmes'

  erb :home
end

get '/chapter/:number' do
  number = params['number'].to_i

  @title = "Chapter #{number}: #{@table_of_contents[number - 1]}"
  @table_of_contents = File.readlines('data/toc.txt')
  @chapter = File.read("data/chp#{number}.txt")

  erb :chapter
end

not_found do
  redirect '/'
end

helpers do
  def in_paragraphs(text)
    text.split("\n\n").map do |line|
      "<p>#{line}</p>"
    end.join
  end
end
