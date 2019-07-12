local collision, tiles = {}, {}
local camera = {x = 0, y = 0}
local player = {speed = 5}
local images = {}

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

  player.img = love.graphics.newImage('hero.png')
  player.img:setFilter('nearest')
end

function love.draw()
  love.graphics.scale(2)

  for x = -camera.x % 1 - 1, 18 do
    for y = -camera.y % 1 - 1, 18 do
      local tile = tiles[x + camera.x - 8 ..','.. y + camera.y - 8]

      if tile then
        love.graphics.draw(images[tile], x * 16, y * 16)
      end
    end
  end

  love.graphics.draw(player.img, 8 * 16, 8 * 16)
end

function love.update(dt)
  if dt > 1 then return end

  if player.direct then
    if player.direct == 1 then
      camera.x = camera.x + dt * player.speed
    elseif player.direct == 2 then
      camera.x = camera.x - dt * player.speed
    elseif player.direct == 3 then
      camera.y = camera.y + dt * player.speed
    elseif player.direct == 4 then
      camera.y = camera.y - dt * player.speed
    end

    player.cooldown = player.cooldown - dt * player.speed
    if player.cooldown < 0 then
      if player.direct % 2 == 1 then
        camera.x = math.floor(camera.x)
        camera.y = math.floor(camera.y)
      else
        camera.x = math.ceil(camera.x)
        camera.y = math.ceil(camera.y)
      end
      player.direct = nil
    end
  else
    local rg = love.keyboard.isDown('d')
    local lf = love.keyboard.isDown('a')
    local dw = love.keyboard.isDown('s')
    local up = love.keyboard.isDown('w')

    if rg and not collision[camera.x + 1 ..','.. camera.y] then
      player.direct = 1
    elseif lf and not collision[camera.x - 1 ..','.. camera.y] then
      player.direct = 2
    elseif dw and not collision[camera.x ..','.. camera.y + 1] then
      player.direct = 3
    elseif up and not collision[camera.x ..','.. camera.y - 1] then
      player.direct = 4
    end

    player.cooldown = 1
  end

end
