class Timer
  public
  def initialize(interval, &callback_block)
    @loop_enable = false
    @interval = interval
    @callback_block = callback_block
  end
  def start()
    @loop_enable = true
    loop_start()
  end
  def stop()
    @loop_enable = false
  end
  private
  def loop_start()
    Thread.new(){
      while @loop_enable
        @callback_block.call()
        sleep(@interval)
      end
    }
  end
end
