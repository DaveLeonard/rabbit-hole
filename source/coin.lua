import "libraries/AnimatedSprite/AnimatedSprite.lua"

local pd <const> = playdate
local gfx <const> = pd.graphics


class("Coin").extends(AnimatedSprite)
  local xConst <const> = 121
  local yConst <const> = 162
  local zConst <const> = 900



  function Coin:init(imagetable,states,animate)
    Coin.super.init(self, imagetable, states, animate)

    self:setCollideRect(0, 0, 22,22)
    self:setGroups(2)
    self:setCollidesWithGroups({1, 2})
    self:setCenter(0, 0)
    self:setZIndex(zConst)
    self:moveCoin()
    self:playAnimation()
  end

 function Coin:moveCoin()
    -- Use a wider range for the random position
    local randX = math.random(0, 400)
    local randY = math.random(0, 240)

    -- Add a random velocity to the coin
    local randVelX = math.random(-5, 5)
    local randVelY = math.random(-5, 5)

    self:moveTo(randX, randY)
    self.velocityX = randVelX
    self.velocityY = randVelY
  end


  function Coin:collisionResponse(other)
      if other:isA(hero) then
        retrun "freeze"
      else
        return "bounce"
      end
  end

  function Coin:update()
      self:updateAnimation()
  end
