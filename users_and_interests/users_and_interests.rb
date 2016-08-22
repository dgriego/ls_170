require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'
require 'psych'

before do
  @users = Psych.load_file('data/users.yaml')
end

get '/' do
  redirect '/users'
end

get '/:user_name' do
  @user_name = params['user_name'].to_sym
  @email = @users[@user_name][:email]
  @interests = @users[@user_name][:interests]

  erb :user
end

get '/users' do
  erb :users
end

helpers do
  def count_interests(users)
    interests = []

    users.each_value { |value| interests << value[:interests] }

    interests.flatten.length
  end
end