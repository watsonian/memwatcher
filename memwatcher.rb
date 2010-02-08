require 'rubygems'
require 'vendor/sinatra/lib/sinatra'
require 'vendor/mem_info/lib/mem_info'
require 'erb'

get '/hi' do
  @foo = MemInfo.new.memused
  erb :index
end