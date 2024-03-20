local pd <const> = playdate
local gfx <const> = pd.graphics


class('Well').extends(gfx.sprite)

  function Well:init(x, y, speed, accel)
    Well.super.init(self)
    local wellImage = gfx.image.new("images/well")
    self:setImage(wellImage)
    self:moveTo(x, y)
    self:setCollideRect(0, 0,self:getSize())
    self:setZIndex(-32768)
    self:setGroups(1)
    self.speed = speed
    self.accel = accel
    self.curSpeed = speed
    self.minSpeed = speed / 2
    self.yOffset = math.random(-25, 25) / 10
    self.dir = 1
  end


   function Well:update()
    Well.super.update(self)
    -- Used for bouncing the arrow back
    -- local actualX, actualY, collisions, collisionsLen = self:moveWithCollisions(self.x + self.dir * self.curSpeed, self.y + self.yOffset)
    -- if collisionsLen ~= 0 then
    --     self.dir *= -1
    --     self:setRotation(180)
    -- end

    newx = self.x + self.dir * self.curSpeed + velX
    newy = self.y + self.yOffset * self.curSpeed + velY


    if(newx<0 or newx>400) then
			if(newx<0) then newx=0 end
			if(newx>400) then newx=400 end
      velX = -velX
      self.yOffset = -self.yOffset
    end

    if(newy<0 or newy>240) then
			if(newy<0) then newy=0 end
			if(newy>240) then newy=240 end
      velY = -velY
      self.yOffset = -self.yOffset
    end

    self:moveWithCollisions(newx,newy)
    self.curSpeed = self.curSpeed - (self.dir * self.accel)
    if math.abs(self.curSpeed) < self.minSpeed then
        self.curSpeed = self.dir * self.minSpeed
    end
  end

  function Well:collisionResponse(other)
      if other:isA(Player) then
        retrun "freeze"
      else
        return "bounce"
      end
  end

function Well:moveWell(otherWell)
    -- Calculate the direction vector between the two wells
    local dx = self.x - otherWell.x
    local dy = self.y - otherWell.y

    -- Normalize the direction vector
    local mag = math.sqrt(dx*dx + dy*dy)
    dx = dx / mag
    dy = dy / mag

    -- Reverse the direction of the wells
    self.dx = -dx
    self.dy = -dy
    otherWell.dx = dx
    otherWell.dy = dy
  end
