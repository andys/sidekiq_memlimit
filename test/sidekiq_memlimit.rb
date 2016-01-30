ENV['SIDEKIQ_MAX_MB'] = '100'
require "minitest/autorun"
require 'sidekiq/cli'
require "#{File.dirname(__FILE__)}/../lib/sidekiq_memlimit"

class TestSidekiqMemlimit < MiniTest::Unit::TestCase
  def test_rss_kb
    SidekiqMemlimit.setup
    SidekiqMemlimit.run_gc
    kb = SidekiqMemlimit.rss_kb
    assert(kb > 0)
    assert_equal "VmRSS:\t%8d kB\n" % kb,
                 File.read("/proc/#{$$}/status").lines.grep(/VmRSS/).first
    SidekiqMemlimit.stop_monitorthread
  end

  def test_monitorthread
    SidekiqMemlimit.setup
    assert SidekiqMemlimit.monitorthread
    SidekiqMemlimit.stop_monitorthread
  end
  
  def test_signal
    received_signal = false
    trap("USR1") { received_signal = true }
    Sidekiq.logger = nil
    assert_equal false, received_signal
    SidekiqMemlimit.setup
    
    # now take up >100MB memory
    x = 'a' * (101 * 1024 * 1024)
    
    sleep 1.1
    assert_equal true, received_signal
    SidekiqMemlimit.stop_monitorthread
  end

  def test_custom_handler
    handler_fired = false
    Sidekiq.logger = nil
    SidekiqMemlimit.setup { handler_fired = true }
    assert_equal false, handler_fired

    # now take up >100MB memory
    x = 'a' * (101 * 1024 * 1024)

    sleep 1.1
    assert_equal true, handler_fired
    SidekiqMemlimit.stop_monitorthread
  end
end
