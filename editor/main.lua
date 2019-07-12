local tiles = {}
local player = {pos = {x = 0, y = 0}}
local images = {}
local time = 0
local selected = 1
local font

function love.load()
  font = love.graphics.newFont(15)
  font:setFilter('nearest')

  local imagedir = love.filesystem.getDirectoryItems('images')
  for i, dir in ipairs(imagedir) do
    print(i, dir)
    images[i] = love.graphics.newImage('images/'..dir)
    images[i]:setFilter('nearest')
  end
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

  love.graphics.rectangle('line', 8 * 16, 8 * 16, 16, 16)
  love.graphics.rectangle('line', (8 - player.pos.x)*16, (8 - player.pos.y)*16, 16, 16)
  love.graphics.print(selected, font, 10, 10)
end

function love.update(dt)
  time = time + dt
  if time > 0.15 then
    time = time - 0.15

    if love.keyboard.isDown('d') then player.pos.x = player.pos.x + 1
    elseif love.keyboard.isDown('a') then player.pos.x = player.pos.x - 1
    elseif love.keyboard.isDown('s') then player.pos.y = player.pos.y + 1
    elseif love.keyboard.isDown('w') then player.pos.y = player.pos.y - 1
    end

    if love.mouse.isDown(1) then
      tiles[player.pos.x ..','.. player.pos.y] = selected
    end
  end
end

function love.wheelmoved(x, y)
  selected = (selected - y - 1) % #images + 1
end

function love.keypressed(key, scancode, isrepeat)
  if key == 'escape' then
    local file = io.open(love.filesystem.getSource()..'map', 'w')
    for k, tile in pairs(tiles) do
      local x, y = k:match('(%S+),(%S+)')
      local coll = tile == 3 and ' coll\n' or '\n'
      file:write(tile ..' '.. x ..','.. y .. coll)
    end
    file:close()
  end
end
