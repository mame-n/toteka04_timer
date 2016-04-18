require "./timermain"
#require "./dummy_timer"

def integer_string?(str)
  return false unless str
  Integer(str)
  true
rescue ArgumentError
  false
end

def float_string?(str)
  return false unless str
  Float(str)
  true
rescue ArgumentError
  false
end

def numerical_string?( str )
  integer_string?( str ) || float_string?( str ) ? true : false
end

tm = Timer_ctrl.new

print "timer >> "
while cmds = STDIN.gets
#  begin
    cmd = cmds.chomp.split
    if numerical_string?( cmd[0] )
      tm.set_time( cmd[0].to_f )
    else
      case cmd[0]
      when "set"
        tm.set_time( cmd[1].to_f )
      when "start"
        tm.start
      when "resume"
        tm.resume
      when "r"
        tm.resume
      when "pause"
        tm.pause
      when "p"
        tm.pause
      when "stop"
        tm.pause
      when "reset"
        tm.reset
      when "cancel"
        tm.cancel
      when "value"
        tm.view_time_value
      when "reset_world"
        tm.reset_world
      when "quit"
        puts "Bye"
        break
      else
        puts "set/start/stop/pause(p)/resume(r)/cancel/reset/reset_world/quit"
      end
    end
    print "timer >> "
#  rescue 
#    tm.cancel
#  end
end
