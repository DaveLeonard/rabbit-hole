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
  
  function Coin:moveCoin()
    local randX = math.random(40, 360)
    local randY = math.random(40, 200)
    self:moveWithCollisions(randX, randY)
  end
  
  function Coin:collisionResponse(other)
      if other:isA(Player) then
        retrun "freeze"
      else
        return "bounce"
      end
  end
  