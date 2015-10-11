require 'haml'
require 'rack/rewrite'
require 'rubygems'
require 'sinatra/base'
require 'sinatra/reloader'

class App < Sinatra::Base
  enable :inline_templates
  enable :logging

  configure :development do
    register Sinatra::Reloader
    set :server, 'webrick'
  end

  get '/' do
    @title = 'Top'
    haml 'My Way'
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
  %title=@title
 %body
  %h1=@title
  %div=yield
