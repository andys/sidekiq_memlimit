class SidekiqMemlimit
  class << self
    attr_accessor :max_mb, :sleep_time
    attr_reader :monitorthread

    def start_monitorthread
      default_killproc = proc do |pid|
        Process.kill('USR1', pid)
        Thread.exit
      end

      if !@monitorthread || !@monitorthread.alive?
        @monitorthread = Thread.new do
          begin
            begin
              mb = rss_mb
              if max_mb && mb > max_mb
                run_gc
                if max_mb && mb > max_mb
                  Sidekiq.logger.error "#{self}: Exceeded max memory limit (#{mb} > #{max_mb} MB)"
                  (@killproc || default_killproc).yield($$)
                end
              end
              sleep sleep_time
            end until @stop
          rescue Exception => e
            Sidekiq.logger.error "#{self}: #{$!.class} exception: #{$!}"
          end
        end
      end
    end

    def run_gc
      GC.start
    end

    def pagesize
      4096
    end

    def rss_mb
      rss_kb >> 10
    end

    def rss_kb
      pagesize * (File.read("/proc/#{$$}/statm").split(' ')[1].to_i rescue 0) >> 10
    end

    def stop_monitorthread
      @stop = true
      @monitorthread.join
      @killproc = nil
    end

    def setup(&proc)
      @killproc = proc
      self.sleep_time ||= 5
      if ENV['SIDEKIQ_MAX_MB']
        self.max_mb = ENV['SIDEKIQ_MAX_MB'].to_i
        self.max_mb = nil unless max_mb > 1
      end
      self.start_monitorthread
    end
  end
end

