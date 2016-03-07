require 'rinda/tuplespace'

class TimerRinda

  def start_timerRinda
    ts = Rinda::TupleSpace.new
    DRb.start_service('druby://localhost:12345', ts)
    DRb.thread.join
  end

end
