local pd <const> = playdate
local gfx <const> = pd.graphics


class('Player').extends(gfx.sprite)

  function Player:init()
    Player.super.init(self)
    local playerImage = gfx.image.new("images/player")
    self:setImage(playerImage)
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