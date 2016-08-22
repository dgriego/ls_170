require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'

before do
  @table_of_contents = File.readlines('data/toc.txt')
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

get '/search' do
  @results = chapters_matching(params['query'])

  erb :search
end

not_found do
  redirect '/'
end

# TA SOLUTION
def each_chapter(&block)
  @table_of_contents.each_with_index do |title, index|
    number = index + 1
    contents = File.read("data/chp#{number}.txt")
    yield number, title, contents
  end
end

def chapters_matching(query)
  results = []

  return results unless query

  each_chapter do |number, title, chapter|
    matches = {}

    chapter.split("\n\n").each_with_index do |paragraph, index|
      matches[index] = paragraph if paragraph.include?(query)
    end

    results << {number: number, title: title, paragraphs: matches} if matches.any?
  end

  results
end

helpers do
  def in_paragraphs(text)
    text.split("\n\n").each_with_index.map do |line, index|
      "<p id='paragraph_#{index}'>#{line}</p>"
    end.join
  end

  def highlight(paragraph, term)
    paragraph.gsub(term, "<strong>#{term}</strong>")
  end
end

# MY SOLUTIONS
# def chapters_matching(query)
#   results = []

#   return results unless query

#   count = 1
#   loop do
#     chapter = File.read("data/chp#{count}.txt").downcase
#     query = params['query'].downcase

#     if chapter.include?(query)
#       results << @table_of_contents[count - 1]
#     end

#     count += 1
#     break if count == 13
#   end

#   results
# end

# def paragraphs_matching(query, chapter)
#   results = []

#   chapter.split("\n\n").each_with_index do |paragraph, index|
#     if paragraph.include?(query)
#       results << { number: index + 1, content: paragraph }
#     end
#   end

#   results
# end
