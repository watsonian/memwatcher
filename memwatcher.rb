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
    @files << hash_from_filename(file)
  end
  erb :processes
end

def megabytes(kilobytes)
  (kilobytes.to_f / 1024.0).floor
end

def readable_date(date, format="%Y/%h/%d %I:%M:%S %p")
  date = DateTime.parse(date)
  date.strftime(format)
end

def date_from_filename(filename)
  File.basename(filename).split("-").first
end

def oldmem_from_filename(filename)
  File.basename(filename).split("-")[1]
end

def newmem_from_filename(filename)
  File.basename(filename).split("-")[2].split(".").first
end

def hash_from_filename(filename)
  {
    :name => date_from_filename(filename),
    :oldmem => oldmem_from_filename(filename),
    :newmem => newmem_from_filename(filename),
    :data => File.open(filename) { |f| f.read }
  }
end