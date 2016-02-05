require 'minecraft-pi-ruby'
require './num_block'
require './timer'

class Timer_ctrl

  def initialize
    @num_mcpi = NumericalMCPI.new
    @timer = Timer.new(1) do
      Thread.new() do
        disp_min( @sec / 60 )
        disp_sec( @sec % 60 )
        @sec -= 1
      end
    end
  end

  def set_time( min )
    @num_mcpi.say "Set time as #{min} min."
    @count_min = min # 0.1 is 6sec
  end

  def start_timer
    @num_mcpi.say "Start as #{@count_min} min !!"

    @sec = (@count_min * 60).to_i
    @timer.start()
    while @sec >= 0
    end
    @timer.stop()
    wait_threads_stop()
  end

  def disp_min( number )
#    puts "#{number} min"
    [8, 0].each do |offset|
      @num_mcpi.ddigt( number % 10, offset )
      number /= 10
    end
  end

  def disp_sec( number )
#    puts "#{number} sec"
    [28, 20].each do |offset|
      @num_mcpi.ddigt( number % 10, offset )
      number /= 10
    end
  end

  def wait_threads_stop(number_of_thread = 1,timeout = 200)
    puts("\n\nWaiting for finishing all threds.")
    c = 0
    while Thread.list.length > number_of_thread
      puts(Thread.list.length)
      c += 1
      if c > timeout then
        puts('time out')
        break
      end
      sleep(0.1)
    end
  end
end

class NumericalMCPI
  def initialize
    @mc = Minecraft.new
  end

  def say( s )
    @mc.say "MCPI::Ruby : #{s}"
  end

  def ddigt( number, digit )

    14.downto(4) do |y|
      0.upto(5) do |x|
        @mc.set_block( x+digit, y, 0, TNum::T[number][14-y][x] )
      end
    end
  end
end


tm = Timer_ctrl.new
tm.set_time( 1.1 )
tm.start_timer
