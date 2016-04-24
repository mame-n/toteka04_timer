require 'rinda/tuplespace'
require './mcpi_ruby'

class Timer_ctrl
  TSURI = 'druby://localhost:9999'
  MaxTimerValue = 99*60+59

  def initialize
    @mcpi = NumericalMCPI.new

    DRb.start_service(TSURI, Rinda::TupleSpace.new)
    @tuple_thread = Thread.new() { DRb.thread.join }

    @set_time = 0
    @pause_time = 0
  end

  def set_time( time_minutes )
    time_seconds = (time_minutes * 60).to_i  # Cut less than 1sec.
    time_seconds = MaxTimerValue if time_seconds > MaxTimerValue
    @mcpi.initial_time_set( time_seconds )
    @set_time = time_seconds
  end
  
  def start( timer_value = @set_time )
    DRb.start_service
    ts = DRbObject.new_with_uri( TSURI )

    @timer_thread = timer_loop_start( ts, timer_value )
    @receive_thread = receive_timer_loop( ts )
  end

  def pause
    puts "Pause : #{@pause_time} sec" unless @pause_time == 0
    thread_kill
    @mcpi.initial_time_set( @pause_time )
  end

  def resume
    start( @pause_time )
  end

  def reset
    set_time( 0 )
  end

  def cancel
    puts "**Stop**"
    thread_kill
    @mcpi.initial_time_set( @set_time )
  end

  def view_time_value
    @mcpi.say "Set time is #{@set_time} sec"
  end

  def reset_world
    puts "* Reset world *"
    @mcpi.reset_world
  end

  private
  def timer_loop_start( ts, time_seconds )
    Thread.new( ts, time_seconds ) do |ts, time_seconds|
      @real_time = Time.now

      time_seconds.downto(0) do |time|
        ts.write( ["timer", time] )
        sleep( 0.970 )
      end
    end
  end

  def receive_timer_loop( ts )
    Thread.new( ts ) do |ts|
      while (time = ts.take(["timer", nil])[1]) >= 0
        @mcpi.display( time )
        @pause_time = time
        break if time == 0
        sleep(0.8)
      end
      puts "End : input \"stop\" and return"
      print "timer >> "
    end
  end

  def thread_kill
    Thread.kill( @timer_thread ) if @timer_thread
    Thread.kill( @receive_thread ) if @receive_thread
    Thread.kill( @tuple_thread ) if @tuple_thread
  end

end

if __FILE__ == $0
  tm = Timer_ctrl.new
  tm.set_time( ARGV[0].to_f )
  tm.start_timer
end
