local pd <const> = playdate
local gfx <const> = pd.graphics


class('Coin').extends(gfx.sprite)

  function Coin:init()
    Coin.super.init(self)
    local coinImage = gfx.image.new("images/carrot")
    self:setImage(coinImage)
    self:setCollideRect(0, 0, self:getSize())
    self:setGroups(1)
  end

 function Coin:moveCoin()
  function Coin:moveCoin()
    -- Use a wider range for the random position
    local randX = math.random(0, 400)
    local randY = math.random(0, 240)

    -- Add a random velocity to the coin
    local randVelX = math.random(-5, 5)
    local randVelY = math.random(-5, 5)

    self:moveWithCollisions(randX, randY)
    self.velocityX = randVelX
    self.velocityY = randVelY
  end
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
