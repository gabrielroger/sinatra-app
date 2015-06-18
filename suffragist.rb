require 'sinatra'
require 'yaml/store'
require 'sinatra/cookies'
set :bind, '0.0.0.0'

set(:cookie_options) do
  { :expires => Time.now + 3600*24*30 }
end

get '/' do
  if cookies[:a_vote]== 'oui'
    redirect to '/results'
  end
	@title = 'Les animaux sont nos amis !'
	erb :index
  end
Choices = {
  'PAN' => 'Panda',
  'CAT' => 'Chat',
  'DOG' => 'Chien',
  'HOR' => 'Cheval',
  'BUN' => 'Lapin',
  'ORA' => 'Orange',
}
post '/cast' do
  @title = "Merci d'avoir voté !"
  cookies[:a_vote] = 'oui'
  @vote  = params['vote']
  @store = YAML::Store.new 'votes.yml'
  @store.transaction do
    @store['votes'] ||= {}
    @store['votes'][@vote] ||= 0
    @store['votes'][@vote] += 1
  end
  erb :cast
end

get '/results' do
  @title = 'Les différents votes :'
  @store = YAML::Store.new 'votes.yml'
  @votes = @store.transaction { @store['votes'] }
  erb :results
end