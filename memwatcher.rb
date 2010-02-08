require 'rubygems'
require 'vendor/sinatra/lib/sinatra'
require 'erb'
require 'mem_info'

get '/hi' do
  @foo = MemInfo.new.memused
  erb :index
end