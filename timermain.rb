require 'rinda/tuplespace'
require './mcpi_ruby'
require 'pp'

class Timer_ctrl
  TSURI = 'druby://localhost:9999'
  MaxTimerValue = 99*60+59

  def initialize
    @mcpi = NumericalMCPI.new

    DRb.start_service(TSURI, Rinda::TupleSpace.new)
    @tuple_thread = Thread.new() { DRb.thread.join }

    @time_seconds = 0
    @pause_time = 0
  end

  def set_time( time_minutes )
    time_seconds = (time_minutes * 60).to_i  # Cut less than 1sec.
    time_seconds = MaxTimerValue if time_seconds > MaxTimerValue

    @mcpi.say "Set time. #{time_seconds/60}:#{time_seconds%60}"
    @mcpi.initial_time_set( time_seconds )
    @time_seconds = time_seconds
  end

  def start
    @mcpi.say "Start timer!!"

    DRb.start_service
    ts = DRbObject.new_with_uri( TSURI )

    @timer_thread = timer_loop_start( ts, @time_seconds )
    puts "Finish send timer"
    @receive_timer = receive_timer_loop( ts )
    puts "Finish receive timer"

#    puts "RESULT #{Time.now - @real_time}"
#    sleep(3)  # wait for stop timer loop thread
  end

  def start_wo_timer_loop
    receive_timer_loop( ts )
    pp Thread.list
  end

  def pause
    puts "Pause : #{@pause_time} sec"
    Thread.kill( @timer_thread )
  end

  def resume
    puts "Resume :"
    set_time( @pause_time/60.0 )
    start
  end

  def reset
    set_time( 0 )
  end

  def stop
    puts "**Stop**"
    Thread.kill( @timer_thread )
    Thread.kill( @tuple_thread )
    sleep(3)  # wait for stop timer loop thread
    pp Thread.list

    set_time( @time_seconds )
  end

  def reset_world
    @mcpi.load_world( "toteka_timer_world.db" )
  end

  private
  def timer_loop_start( ts, time_seconds )
    Thread.new( ts, time_seconds ) do |ts, time_seconds|
      @real_time = Time.now

      time_seconds.downto(0) do |time|
#        puts "**S : #{time}"
        ts.write( ["timer", time] )
        sleep( 0.970 )
      end
    end
  end

  def receive_timer_loop( ts )
    Thread.new( ts ) do |ts|
      while (time = ts.take(["timer", nil])[1]) >= 0
        puts "**R : #{time}"
        @mcpi.display( time )
        @pause_time = time
        break if time == 0
        sleep(0.8)
      end
    end
  end

end

if __FILE__ == $0
  tm = Timer_ctrl.new
  tm.set_time( ARGV[0].to_f )
  tm.start_timer
end
