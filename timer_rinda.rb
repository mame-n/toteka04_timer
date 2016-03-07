require 'rinda/tuplespace'

class Timer_rinda

  def start_timerRinda
    ts = Rinda::TupleSpace.new
    Thread.new() do
      DRb.start_service('druby://localhost:9999', ts)
      puts DRb.uri
      DRb.thread.join
    end
  end

end
