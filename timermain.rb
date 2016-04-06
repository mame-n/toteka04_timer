require 'rinda/tuplespace'
require './mcpi_ruby'
require 'pp'

class Timer_ctrl
  TSURI = 'druby://localhost:9999'

  def initialize
    @mcpi = NumericalMCPI.new

    DRb.start_service(TSURI, Rinda::TupleSpace.new)
    Thread.new() { DRb.thread.join }
  end

  def set_time( time_minutes )
    DRb.start_service
    @ts = DRbObject.new_with_uri( TSURI )

    total_sec = (time_minutes * 60).to_i  # Cut less than 1sec.
    total_sec = 99*60+59 if total_sec > 99*60+59

    @mcpi.say "Set time. #{total_sec/60}:#{total_sec%60}"
    @mcpi.initial_time_set( total_sec )
  end

  def timer_loop_start
    Thread.new( @ts, @total_sec ) do |ts, total_sec|
      @real_time = Time.now

      total_sec.downto(0) do |time_sec|
        @ts.write(["timer", time_sec])
        sleep( 0.970 )
      end
    end
  end

  def start_timer
    @mcpi.say "Start timer!!"

    timer_loop_start

    while (timer_sec = @ts.take(["timer", nil])[1]) != 0
      puts "#{timer_sec}"
      @mcpi.display( timer_sec )
      sleep(0.8)
    end

    puts "RESULT #{Time.now - @real_time}"
    sleep(3)  # wait for stop timer loop thread

    pp Thread.list
  end

  def reset_timer
    @mcpi.load_world( "toteka_timer_world.db" )
  end
end

if __FILE__ == $0
  tm = Timer_ctrl.new
  tm.set_time( ARGV[0].to_f )
  tm.start_timer
end
