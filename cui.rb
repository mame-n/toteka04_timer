require "./timermain"
#require "./dummy_timer"

def integer_string?(str)
  Integer(str)
  true
rescue ArgumentError
  false
end

def float_string?(str)
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
  cmd = cmds.chomp.split
  if numerical_string?( cmd[0] )
    tm.set_time( cmd[0].to_f )
  else
    case cmd[0]
    when "set"
      tm.set_time( cmd[1].to_f )
    when "start"
      tm.start_timer
    when "resume"
      tm.resume_timer
    when "pause"
      tm.pause_timer
    when "reset"
      tm.reset_timer
    when "quit"
      puts "Bye"
      break
    else
      puts "set/start/resume/pause/reset/quit"
    end
  end
  print "timer >> "
end
