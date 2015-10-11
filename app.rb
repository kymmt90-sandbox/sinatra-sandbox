require 'haml'
require 'rack/rewrite'
require 'rubygems'
require 'sinatra/base'
require 'sinatra/reloader'
require 'padrino-helpers'

class App < Sinatra::Base
  enable :inline_templates
  enable :logging

  configure :development do
    register Sinatra::Reloader
    set :server, 'webrick'
  end

  register Padrino::Helpers

  get '/' do
    haml :index
  end

  get '/name/:name' do
    @name = params[:name]
    @title = "Song for #{@name}"
    haml "#{@name}'s Way"
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
