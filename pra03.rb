require "./pra02"

class Foo2 < Foo
  def bar( x, y )
    super( x+10 )
    puts "super::bar( #{x} )"
  end

  def bar3( x, y, z )
    bar( y, z )
    puts "bar( #{x}, #{y}, #{z} )"
  end
end


obj = Foo2.new
obj.bar( 22, 10 )
obj.bar3( 10, 20, 30 )
