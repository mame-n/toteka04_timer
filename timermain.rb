require './mcpi_ruby'

class Timer_ctrl
  def initialize
    @mcpi = NumericalMCPI.new
  end

  def set_time( min )
    @time_sec = (min*60).to_i
    disp_time( @time_sec )
  end

  def start_timer
      @time_sec.downto(0) do |t_sec|
        disp_time( t_sec )
        sleep(0.9)
    end
  end

  def disp_time( total_sec )
    puts total_sec
    min = total_sec / 60
    sec = total_sec % 60
    
    @mcpi.disp_sec( sec )
    @mcpi.disp_min( min )
  end
end

ot = Timer_ctrl.new
ot.set_time( ARGV[0].to_f )
ot.start_timer
