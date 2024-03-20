local pd <const> = playdate
local gfx <const> = pd.graphics


class('Player').extends(gfx.sprite)

  function Player:init()
    Player.super.init(self)
    --local playerImage = gfx.image.new("images/player")
    local player = gfx.sprite.new()
    player.imagetable = gfx.imagetable.new("images/bunny_sprite")
    player.animation = gfx.animation.loop.new(100, player.imagetable, true)
    --self:setImage(playerImage)
    self:moveTo(200, 120)
    self:setCollideRect(0, 0, self:getSize())
    self:setGroups(1)
  end

  function Player:raz()
    local goalX = math.random(40, 360)
    local goalY = math.random(40, 200)
    --need a global var!
    self:moveWithCollisions(goalX, goalY)
  end

--   function Player:moveBy(dx, dy)
--     -- Move the player by dx, dy
--     self:moveWithCollisions(self.x + dx, self.y + dy)
--
--     -- Change the image based on the direction of movement
--     if dx > 0 then
--       self:setImage(gfx.image.new("images/player_right"))
--     elseif dx < 0 then
--       self:setImage(gfx.image.new("images/player_left"))
--     elseif dy > 0 then
--       self:setImage(gfx.image.new("images/player_down"))
--     elseif dy < 0 then
--       self:setImage(gfx.image.new("images/player_up"))
--     else
--       self:setImage(gfx.image.new("images/player"))
--     end
--   end

