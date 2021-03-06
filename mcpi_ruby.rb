require 'socket'
require 'minecraft-pi-ruby'
require './num_block'

class Minecraft
  def reset
    set_blocks(-100, 0,  -100, 100, 63, 100, Block::AIR)
    set_blocks(-100, -1,  -100, 100, 1, 100, Block::GRASS)
    set_blocks(-100, -63,  -100, 100, -2, 100, Block::STONE)

    set_player_position( $player_posi )
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
  $player_posi_10sec = [26, 7, 10, :normal]
  $player_posi = [19, 5, 18, :normal]

  def initialize
    @mc = Minecraft.new
    @prev_sec = 0
    player_position( $player_posi )
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
    color = block_color( false )
    disp_sec( total_sec % 60, color )
    disp_min( total_sec / 60, color )
    dot( color )
    @prev_sec = total_sec % 60

    player_position( $player_posi )
  end

  def display( total_sec )
    min = total_sec / 60
    sec = total_sec % 60

    block_color = block_color( total_sec < 10 ? true : false )
    if total_sec == 9
      player_position( $player_posi_10sec )
      disp_min( min, block_color )
      dot( block_color )
      @mc.say "                Prepare of applause!!!"
    end

    disp_sec( sec, block_color )
    if @prev_sec <= sec
      disp_min( min, block_color )
      @prev_sec = sec
    end
    
    if total_sec == 0
      @mc.say "       Applause!!!  Applause!!!   Applause!!!"
      @mc.say "     88888888888888888888888888888888888888"
    end
  end

  def reset_world
    @mc.set_blocks(-100, 0,  -100, 100, 63, 100, Block::AIR)
    @mc.set_blocks(-100, -1,  -100, 100, 1, 100, Block::GRASS)
    @mc.set_blocks(-100, -63,  -100, 100, -2, 100, Block::STONE)

    player_position( $player_posi )
  end

  private
  def disp_min( number, block_color )
    [9, 1].each do |offset|
      ddigt( number % 10, offset, block_color )
      number /= 10
    end
  end

  def disp_sec( number, block_color )
    [28, 20].each do |offset|
      ddigt( number % 10, offset, block_color )
      number /= 10
    end
  end

  def ddigt( number, digit, block_color )
    14.downto(4) do |y|
      0.upto(5) do |x|
        @mc.set_block( x+digit, y, 0, block_color * TNum::T[number][14-y][x] )
      end
    end
  end

  def block_color( block )
    block ? Block::GOLD_BLOCK : Block::STONE
  end

  def player_position( status )
    @mc.set_player_position( status[0], status[1], status[2] )
  end

  def dot(block_color)
    @mc.set_block( 17, 11, 0, block_color )
    @mc.set_block( 17,  7, 0, block_color )
  end
end

#NumericalMCPI.new.ddigt(8, 28)
#NumericalMCPI.new
