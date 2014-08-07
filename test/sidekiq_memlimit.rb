ENV['SIDEKIQ_MAX_MB'] = '100'
require "minitest/autorun"
require 'sidekiq/cli'
require "#{File.dirname(__FILE__)}/../lib/sidekiq_memlimit"

class TestSidekiqMemlimit < MiniTest::Unit::TestCase
  def test_rss_kb
    SidekiqMemlimit.run_gc
    kb = SidekiqMemlimit.rss_kb
    assert(kb > 0)
    assert_equal "VmRSS:\t%8d kB\n" % kb,
                 File.read("/proc/#{$$}/status").lines.grep(/VmRSS/).first
  end

  def test_monitorthread
    assert SidekiqMemlimit.monitorthread
  end
  
  def test_signal
    received_signal = false
    trap("USR1") { received_signal = true }
    Sidekiq.logger = nil
    assert_equal false, received_signal
    
    # now take up >100MB memory
    x = 'a' * (101 * 1024 * 1024)
    
    sleep 1.1
    assert_equal true, received_signal
  end
end
