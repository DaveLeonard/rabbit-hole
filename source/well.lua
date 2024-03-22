import "libraries/AnimatedSprite/AnimatedSprite.lua"

local pd <const> = playdate
local gfx <const> = pd.graphics


class("Well").extends(AnimatedSprite)
  local xConst <const> = 121
  local yConst <const> = 162
  local zConst <const> = 0


  function Well:init(imagetable,states,animate, x, y, speed, accel)
    Well.super.init(self,imagetable,states,animate, x, y, speed, accel)

    self.speed = speed
    self.accel = accel
    self.curSpeed = speed
    self.minSpeed = speed / 2
    self.yOffset = math.random(-25, 25) / 10
    self.dir = 1

    self:setCollideRect(0, 0,44,44)
    self:setGroups(1)
    self:setCollidesWithGroups({1, 2})
    self:setCenter(0, 0)
    self:setZIndex(zConst)
    self:moveTo(x, y)
    self:playAnimation()

  end


   function Well:update()
    -- Used for bouncing the arrow back
    -- local actualX, actualY, collisions, collisionsLen = self:moveWithCollisions(self.x + self.dir * self.curSpeed, self.y + self.yOffset)
    -- if collisionsLen ~= 0 then
    --     self.dir *= -1
    --     self:setRotation(180)
    -- end

    newx = self.x + self.dir * self.curSpeed + velX
    newy = self.y + self.yOffset * self.curSpeed + velY


    if(newx<0 or newx>400) then
			if(newx<0) then newx=44 end
			if(newx>400) then newx=358 end
      velX = -velX
      self.yOffset = -self.yOffset
    end

    if(newy<0 or newy>240) then
			if(newy<0) then newy=44
       end
			if(newy>240) then newy=198 end
      velY = -velY
      self.yOffset = -self.yOffset
    end

    self:moveTo(newx,newy)
    self.curSpeed = self.curSpeed - (self.dir * self.accel)
    if math.abs(self.curSpeed) < self.minSpeed then
        self.curSpeed = self.dir * self.minSpeed
    end
     self:updateAnimation()
  end

  function Well:collisionResponse(other)
      if other:isA(hero) then
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
