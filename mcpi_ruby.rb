require 'socket'
require './minecraft-pi-ruby'
require './num_block'

class Minecraft
  def reset
    set_blocks(-100, 0,  -100, 100, 63, 100, Block::AIR)
    set_blocks(-100, -1,  -100, 100, 1, 100, Block::GRASS)
    set_blocks(-100, -63,  -100, 100, -2, 100, Block::STONE)

    set_player_position(23, 2, 19)
    set_view_direction( 5, 0, 1 )
  end

  def get_block(x,y,z)
    @connection.send_with_response "world.getBlock(#{x}, #{y}, #{z})"
    return 
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
  $player_posi_10sec = [
                        [  53,  10,  51, :follow],
                        [ -20,   0, 102, :follow],
                        [ -94,   0,  -7, :follow],
                        [  10,  10, -50, :follow],
                        [  10,  20,  10, :follow],
                        [ -80,  10,-100, :follow],
                        [  10,   0,  80, :follow],
                        [  30,  10,  10, :follow],
                        [ 100,  10,  30, :follow],
                        [  53,  10,  85, :follow],
                        [ 100,  10,  30, :follow],
                       ]

  $player_posi = [23, 2, 19, :normal]

  def initialize
    @mc = Minecraft.new
    @prev_sec = 0
  end

  def self.say( s )
    Minecraft.new.say "MCPI::Ruby : #{s}"
  end

  def say( s )
    @mc.say "MCPI::Ruby : #{s}"
  end

  def load_world( dbn )
    block_world = PStore.new( dbn )

    block_world.transaction( true ) do
      block_world['root'].each_with_index do |wall, x|
        puts "The #{x}th wall"
        wall.each_with_index do |prop, z|
          prop.inject( prop.shift ) do |height, block|
            @mc.set_block( x - 100, height, z - 100 )
            height + 1
          end
        end
      end
    end
  end

  def initial_time_set( total_sec )
    disp_sec( total_sec % 60, false )
    disp_min( total_sec / 60, false )
    @prev_sec = total_sec % 60

    player_position( $player_posi )
  end

  def display( total_sec )
    min = total_sec / 60
    sec = total_sec % 60
    
    block_highlite = total_sec < 10 ? true : false
    disp_min( min, block_highlite ) if total_sec == 9

    disp_sec( sec, block_highlite )
    if @prev_sec <= sec
      disp_min( min, block_highlite )
      @prev_sec = sec
    end

    #    crap_crap if total_sec == 0 if total_sec == 0
  end

  private
  def disp_min( number, block )
    [8, 0].each do |offset|
      ddigt( number % 10, offset, block )
      number /= 10
    end
  end

  def disp_sec( number, block )
    [28, 20].each do |offset|
      ddigt( number % 10, offset, block )
      number /= 10
    end
  end

  def ddigt( number, digit, block )
    block_color = block ? Block::GOLD_BLOCK : Block::STONE
#    puts "**** #{block_color}"
    14.downto(4) do |y|
      0.upto(5) do |x|
        @mc.set_block( x+digit, y, 0, block_color * TNum::T[number][14-y][x] )
      end
    end
  end

  def player_position( status )
    @mc.set_player_position( status[0], status[1], status[2] )
    #    @mc.set_camera_mode( status[3] )
  end

  def crap_crap()
    30.times do
      close_hand
      sleep( 0.1 )
      open_hand
      sleep( 0.6 )
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
