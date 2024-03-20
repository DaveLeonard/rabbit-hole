local pd <const> = playdate
local gfx <const> = pd.graphics


class('Coin').extends(gfx.sprite)

  function Coin:init()
    Coin.super.init(self)
    local coinImage = gfx.image.new("images/tile_0042")
    self:setImage(coinImage)
    self:setCollideRect(0, 0, self:getSize())
    self:setGroups(1)
  end

function Coin:moveCoin(otherCoin)
  local minDistance = 99 -- minimum distance between coins
  local randX, randY
  repeat
    randX = math.random(40, 360)
    randY = math.random(40, 200)
  until (otherCoin == nil) or (math.sqrt((randX - otherCoin.x)^2 + (randY - otherCoin.y)^2) >= minDistance)
  self:moveWithCollisions(randX, randY)
    self.velocityX = randVelX
    self.velocityY = randVelY
 end

  function Coin:collisionResponse(other)
      if other:isA(Player) then
        retrun "freeze"
      else
        return "bounce"
      end
  end
