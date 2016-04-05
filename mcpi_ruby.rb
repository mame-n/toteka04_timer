require 'minecraft-pi-ruby'
require './num_block'

class Minecraft
  def reset
    set_blocks(-100, 0,  -100, 100, 63, 100, Block::AIR)
    set_blocks(-100, -1,  -100, 100, 1, 100, Block::GRASS)
    set_blocks(-100, -63,  -100, 100, -2, 100, Block::STONE)

    set_player_position(23, 2, 19)
    set_view_direction( 5, 0, 1 )
  end

  def set_view_direction( *arg )
    if arg.length == 1
      puts "#{arg[0].x}"
    elsif arg.length == 3
      puts "#{arg[0]}: #{arg[1]}: #{arg[2]}"
    end
  end
end

class NumericalMCPI
  def initialize
    @mc = Minecraft.new
#    @mc.reset
  end

  def self.say( s )
    Minecraft.new.say "MCPI::Ruby : #{s}"
  end

  def disp_min( number )
    [8, 0].each do |offset|
      ddigt( number % 10, offset )
      number /= 10
    end
  end

  def disp_sec( number )
    [28, 20].each do |offset|
      ddigt( number % 10, offset )
      number /= 10
    end
  end

  def player_position( status )
    @mc.set_player_position( status[0], status[1], status[2] )
    @mc.set_camera_mode( status[3] )
  end

  def crap_crap()
    30.times do
      close_hand
      sleep( 0.1 )
      open_hand
      sleep( 0.6 )
    end
  end

  private
  def ddigt( number, digit )
    14.downto(4) do |y|
      0.upto(5) do |x|
        block = TNum::T[number][14-y][x]
        @mc.set_block( x+digit, y, 0, block )
      end
    end
  end

  def open_hand
    14.downto(4) do |y|
      0.upto(5) do |x|
#        block = THand::Open_hand[14-y][x]
        block = TNum::T[0][14-y][x]
        @mc.set_block( x, y, 0, block )
      end
    end
  end

  def close_hand
    14.downto(4) do |y|
      0.upto(5) do |x|
#        block = THand::Close_hand[14-y][x]
        block = TNum::T[0][14-y][x]
        @mc.set_block( x, y, 0, block )
      end
    end
  end
end

#NumericalMCPI.new.ddigt(8, 28)
#NumericalMCPI.new

