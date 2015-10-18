require 'sinatra/base'
require 'sinatra/reloader'

require 'haml'
require 'rack/rewrite'
require 'rubygems'

require 'padrino-cache'
require 'padrino-core'
require 'padrino-helpers'

class App < Sinatra::Base
  enable :inline_templates
  disable :logging

  set :app_name, 'App'
  register Padrino::Routing
  register Padrino::Cache
  enable :caching

  register Padrino::Helpers

  use Padrino::Logger::Rack, '/'

  get '/' do
    haml :index
  end

  get '/name/:name' do
    @name = params[:name]
    @title = "Song for #{@name}"
    haml "#{@name}'s Way"
  end

  get '/heavy_contents', :cache => true do
    expires_in 60
    sleep 5
    'Process done!'
  end

  use Rack::Rewrite do
    rewrite %r{^/song_for/(.*)}, '/name/$1'
  end
end

App.run!

__END__

@@ layout
!!! 5
%html
 %head
  %title= yield_content(:title) || @title
 %body
  %h1= yield_content(:header) || @title
  %div=yield

@@ index
- content_for :title do
  This is title from helper
- content_for :header do
  This is header from helper
%p My Way
