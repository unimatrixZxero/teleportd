require './lib/teleportd.rb'

include Teleportd
Teleportd::Config.token = YAML::load(File.open(File.join 'config', 'teleportd.yml'))['token']

class TeleportdApp < Sinatra::Base
  set :public_folder, File.dirname(__FILE__) + '/static'

  get '/' do
    @pics = Teleportd::search_location('52.29', '13.22', 1.0, 1.0, params[:page].to_i) #Berlin, Germany
    @page = params[:page].to_i
    haml :index, format: :html5
  end

  get '/more' do
    @pics = Teleportd::search_location('52.29', '13.22', 1.0, 1.0, params[:page].to_i) #Berlin, Germany
    haml :pics, format: :html5
  end

  # enterprise key only feature
  get '/details' do
    @pic = details(params[:sha])
    haml :details
  end
end