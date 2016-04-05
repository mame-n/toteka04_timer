require 'rinda/tuplespace'
require './mcpi_ruby'
require 'pp'

class Timer_ctrl
  TSURI = 'druby://localhost:9999'

  def initialize
    timer_tapleSpace
  end

  def timer_tapleSpace
    DRb.start_service(TSURI, Rinda::TupleSpace.new)
    Thread.new() { DRb.thread.join }
  end

  def set_time( time_minutes )
#    NumericalMCPI.say "Set time as #{time_minutes} min."
    DRb.start_service
    @ts = DRbObject.new_with_uri( TSURI )
    @total_sec = (time_minutes * 60).to_i # Cut less than 1sec.
    @prev_sec = @total_sec % 60
    disp_time( @total_sec )
  end

  def timer_loop_start
    Thread.new( @ts, @total_sec ) do |ts, total_sec|
      @real_time = Time.now
      total_sec.downto(0) do |time_sec|
        ts.write(["timer", time_sec])
        sleep( 0.970 )
      end
    end
  end

  def start_timer
    NumericalMCPI.say "Start timer!!"
    timer_loop_start

    while (timer_sec = @ts.take(["timer", nil])[1]) != 0
      puts "#{timer_sec}"
      disp_time( timer_sec )
      sleep(0.8)
    end
    disp_time( 0 )
    puts "RESULT #{Time.now - @real_time}"
    sleep(3)  # wait for stop timer loop thread

    pp Thread.list
  end

  def disp_time( total_sec )
    min = total_sec / 60
    sec = total_sec % 60

    player_posi_10sec = [
                         [  10,  10,  10, :normal],
                         [ -20,  10, 100, :normal],
                         [ 100,  10,  10, :normal],
                         [  90,  80, -20, :normal],
                         [-100,  10,   0, :follow],
                         [  10,  10, -50, :normal],
                         [  10,  60,  10, :normal],
                         [ -80,  10,-100, :follow],
                         [  10, -10,  80, :normal],
                         [  30,  10,  10, :normal],
                         [ 100,  10,  30, :normal],
                        ]
    mcpi = NumericalMCPI.new

    if total_sec > 10
      mcpi.player_position( [23, 2, 19, :normal] )
      mcpi.disp_sec( sec )
      mcpi.disp_min( min ) if @prev_sec <= sec
      @prev_sec = sec

    elsif total_sec <= 10 && total_sec > 0
      mcpi.player_position( player_posi_10sec[total_sec] )

    elsif total_sec == 0
      mcpi.player_position( [50, 10, 50, :normal] )
#      mcpi.crap_crap

    else
      NumericalMCPI.say "Illegal time. #{total_sec}"
    end
  end
end

if __FILE__ == $0
  tm = Timer_ctrl.new
  tm.set_time( ARGV[0].to_f )
  tm.start_timer
end
