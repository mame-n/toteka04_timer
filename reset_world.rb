require 'minecraft-pi-ruby'

mc = Minecraft.new

mc.set_blocks(-100, 0,  -100, 100, 63, 100, Block::AIR)
mc.set_blocks(-100, -1,  -100, 100, 1, 100, Block::GRASS)
mc.set_blocks(-100, -63,  -100, 100, -2, 100, Block::STONE)

mc.set_player_position(23, 2, 19)
