require "pstore"
require "minecraft-pi-ruby"
require "mcpi_ruby"

maxx = maxz = 100
minx, minz = -1 * maxx, -1 * maxx
maxy, miny = 63, 0

$mc = Minecraft.new

def steal_world( minx, maxx, maxy, minz, maxz )
  (minx..maxx).map do |x|
   steal_wall( x, maxy, minz, maxz )
  end
end

def steal_wall( x, maxy, minz, maxz )
  puts "The #{x}th wall"

  (minz..maxz).map do |z|
    ground_level = $mc.get_ground_height( x, z ).to_i
    steal_prop( x, z, ground_level, maxy ).unshift( ground_level )
  end
end

def steal_prop( x, z, g_level, maxy )
  puts "The #[z]th prop"

  (g_level..maxy).map do |y|
    $mc.get_block( x, y, z )
  end
end

block_world = PStore.new( "toteka_timer_world.db" )
block_world.transaction do
  block_world['root'] = steal_world( minx, maxx, maxy, minz, maxz )
end
