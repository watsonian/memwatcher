require 'rubygems'
require 'yaml'
require 'sinatra'
require 'mem_info'
require 'fileutils'
require 'erb'

class MemWatcher < Sinatra::Base
  set :views, File.join(File.dirname(settings.root), "/views")
  set :public_folder, File.join(File.dirname(settings.root), "/public")

  @@memory_threshold = 50000
  @@max_memused = @@memory_threshold
  @@num_checks = 0
  @@max_checks = 6
  @@logs_to_keep = 25

  #####
  # Actions

  get '/' do
    @memory_threshold = @@memory_threshold
    @file_list = get_log_list
    @files = []
    @file_list.each do |file|
      @files << hash_from_filename(file)
    end
    erb :index
  end

  get '/memcheck' do
    begin
      @meminfo = MemInfo.new
      @max_memused = @@max_memused
      if mem_increased?(@meminfo)
        save_process_list!(@meminfo)
        @max_memused = update_max_memused!(@meminfo)
      end

      check_cleanup!
      cleanup_logs!

      erb :memcheck
    rescue MemInfo::NoProcData => e
      status 500
      e.message
    end
  end

  put '/max_memused' do
    begin
      @@memory_threshold = params[:memory_threshold].to_i
      status 200
      "Update Succeeded"
    rescue
      status 500
      "Update Failed"
    end
  end


  #####
  # Helpers

  helpers do
    def mem_increased?(cur_meminfo)
      cur_meminfo.memused > @@max_memused
    end

    def update_max_memused!(cur_meminfo)
      @@max_memused = cur_meminfo.memused 
    end

    def save_process_list!(cur_meminfo)
      FileUtils.mkdir_p("./log/procs")
      system("ps auxf > log/procs/`date \"+%Y%m%d_%H%M%S-#{@@max_memused}-#{cur_meminfo.memused}\"`.snapshot.out")
    end

    def check_cleanup!
      @@num_checks += 1
      if @@num_checks > @@max_checks
        @@num_checks = 1
        @@max_memused = @@memory_threshold
      end
    end
    
    def get_log_list
      Dir.glob("log/procs/*.snapshot.out").sort.reverse
    end
    
    def cleanup_logs!
      logs = get_log_list
      FileUtils::rm_f(logs[@@logs_to_keep..-1]) unless @@logs_to_keep > logs.size
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
    
    def megabytes(kilobytes)
      (kilobytes.to_f / 1024.0).floor
    end
    
    def cycle
      %w{even odd}[@_cycle = ((@_cycle || -1) + 1) % 2]
    end

    CYCLE = %w{even odd}
    def cycle_fully_sick
      CYCLE[@_cycle = ((@_cycle || -1) + 1) % 2]
    end
  end
end