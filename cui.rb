require "thread"
require "./timermain"

cmds_queue = Queue.new
tm = Timer_ctrl.new

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

main_thread = Thread.start do
  while cmds = cmds_queue.deq
    puts "Activate commands thread #{main_thread} = #{cmds}"
    if numerical_string?( cmds[0] )
      tm.set_time( cmds[0].to_f )
    else
      case cmds[0]
      when "set"
        tm.set_time( cmds[1].to_f )
      when "start"
        tm.start
      when "r"  # Resume
        tm.resume
      when "resume"
        tm.resume
      when "p"  # Pause
        tm.pause
      when "pause"
        tm.pause
      when "cancel"
        tm.cancel
      when "reset"
        tm.reset
      when "value"
        tm.view_time_value
      when "world"
        tm.reset_world
      when "quit"
        tm.quit
        puts "Bye"
      else
        puts "set/start/resume/pause/reset/quit"
      end
    end
    sleep 1
#    puts "Finish calling tm"
  end
end

def kill_thread (t_name)
  Thread.kill(t_name)
end

begin
  print "timer >> "
  cmds = gets.chomp.split
  cmds_queue.enq(cmds)
#  if "quit" == cmds[0]
#    puts "Fin"
#    sleep 4
#    kill_thread(main_thread)
#    break
#  end
end while cmds

main_thread.join
