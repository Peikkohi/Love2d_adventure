local collision, tiles = {}, {}
local player = {pos = {x = 0, y = 0}}
local images = {}
local hero
local time = 0

function love.load()
  local file = io.open(love.filesystem.getSource()..'map', 'r')
  for line in file:lines() do
    local item, pos, coll = line:match('(%S+) (%S+) ?(.*)')

    if item and pos then
      tiles[pos] = tonumber(item)

      if coll ~= '' then collision[pos] = true end
    end
  end
  file:close()

  local imagedir = love.filesystem.getDirectoryItems('images')
  for i, dir in ipairs(imagedir) do
    images[i] = love.graphics.newImage('images/'..dir)
    images[i]:setFilter('nearest')
  end

  hero = love.graphics.newImage('hero.png')
  hero:setFilter('nearest')
end

function love.draw()
  love.graphics.scale(2)

  for x = 0, 17 do
    for y = 0, 17 do
      local tile = tiles[x + player.pos.x - 8 ..','.. y + player.pos.y - 8]

      if tile then
        love.graphics.draw(images[tile], x * 16, y * 16)
      end
    end
  end

  love.graphics.draw(hero, 8 * 16, 8 * 16)
end

function love.update(dt)
  time = time + dt
  if time > 0.15 then
    time = time - 0.15

    local rg = love.keyboard.isDown('d')
    local lf = love.keyboard.isDown('a')
    local dw = love.keyboard.isDown('s')
    local up = love.keyboard.isDown('w')


    if rg and not collision[player.pos.x + 1 ..','.. player.pos.y] then
      player.pos.x = player.pos.x + 1
    elseif lf and not collision[player.pos.x - 1 ..','.. player.pos.y] then
      player.pos.x = player.pos.x - 1
    elseif dw and not collision[player.pos.x ..','.. player.pos.y + 1] then
      player.pos.y = player.pos.y + 1
    elseif up and not collision[player.pos.x ..','.. player.pos.y - 1] then
      player.pos.y = player.pos.y - 1
    end
  end
end
