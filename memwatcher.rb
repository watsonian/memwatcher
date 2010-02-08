require 'rubygems'
require 'vendor/sinatra/lib/sinatra'
require 'vendor/mem_info/lib/mem_info'
require 'erb'

get '/hi' do
  @mem_used = MemInfo.new.memused
  erb :index
end

get '/processes' do
  @file_list = Dir.glob("log/procs/*.snapshot.out").sort.reverse
  @files = []
  @file_list.each do |file|
    @files << { :name => date_from_filename(file), :data => File.open(file) { |f| f.read } }
  end
  erb :processes
end

def readable_date(date, format="%Y/%h/%d %I:%M:%S %p")
  date = DateTime.parse(date)
  date.strftime(format)
end

def date_from_filename(filename)
  File.basename(filename).split(".").first
end