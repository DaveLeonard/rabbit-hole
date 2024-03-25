--[[
   ____              __       __          __    __  __          ___
  /\  _`\           /\ \     /\ \      __/\ \__/\ \/\ \        /\_ \
  \ \ \L\ \     __  \ \ \____\ \ \____/\_\ \ ,_\ \ \_\ \    ___\//\ \      __
   \ \ ,  /   /'__`\ \ \ '__`\\ \ '__`\/\ \ \ \/\ \  _  \  / __`\\ \ \   /'__`\
    \ \ \\ \ /\ \L\.\_\ \ \L\ \\ \ \L\ \ \ \ \ \_\ \ \ \ \/\ \L\ \\_\ \_/\  __/
     \ \_\ \_\ \__/.\_\\ \_,__/ \ \_,__/\ \_\ \__\\ \_\ \_\ \____//\____\ \____\
      \/_/\/ /\/__/\/_/ \/___/   \/___/  \/_/\/__/ \/_/\/_/\/___/ \/____/\/____/

  Author:        David Senate
  Creation date: 03-18-2024
  Update date:   03-22-2024
  Version :      1.0.16

  This file defines the behavior of a hero character in the game. It extends the AnimatedSprite class and provides methods for initializing, reviving, and updating the hero.
  The hero can move in four directions (up, down, left, right) based on button inputs. It also has a death animation when it dies.

  Usage:
  - Create a new instance of the Hero class using the `Hero:init()` method.
  - Call the `Hero:update()` method in the game loop to update the hero's position and animation.
  - Call the `Hero:raz()` method to revive the hero at a random position.
  - Call the `Hero:death()` method to play the death animation when the hero dies.

  Example:
  local hero = Hero()
  hero:init(imagetable, states, animate)
  hero:update()
  hero:raz()
  hero:death()
]]

import "libraries/AnimatedSprite/AnimatedSprite.lua"

local pd <const> = playdate
local gfx <const> = pd.graphics

-- Class hero which allows to define the behavior of a hero
class("Hero").extends(AnimatedSprite)

  -- Constants for initial hero position and z-index
  local xConst <const> = 121
  local yConst <const> = 162
  local zConst <const> = 10000


  function Hero:init(imagetable,states,animate)
    Hero.super.init(self, imagetable, states, animate)

    self:setCollideRect(0, 0, self:getSize())
    self:setGroups(1)
    self:setCollidesWithGroups({1, 2})
    self:setCenter(0, 0)
    self:setZIndex(zConst)
    self:moveTo(xConst, yConst)
    self:playAnimation()

  end

-- Revive a heroo
  function Hero:raz()
    local goalX = math.random(40, 360)
    local goalY = math.random(40, 200)
    --need a global var!
    self:moveTo(goalX, goalY)
  end

  function Hero:death()
    local x, y = self:getPosition()
    local imgtableDeath  = gfx.imagetable.new("images/misc-table-22-22")
    playerDeath = AnimatedSprite.new(imgtableDeath)
    playerDeath:addState('dead', 154, 155, {tickStep = 10})
    playerDeath:moveTo(x,y)
    playerDeath:playAnimation()
    screenShake(200, 6)
  end

  function Hero:dead()
    local x, y = self:getPosition()
    local imgtableDeath  = gfx.imagetable.new("images/misc-table-22-22")
    playerDeath = AnimatedSprite.new(imgtableDeath)
    playerDeath:addState('dead', 154, 155, {tickStep = 10})
    playerDeath:moveTo(x,y)
    playerDeath:playAnimation()
  end

-- update the hero's position and animation.
  function Hero:update()

    -- Get the current position
    local x, y = self:getPosition()

    -- Movements based on button inputs
    if pd.buttonIsPressed( pd.kButtonUp ) and y > 20 then
        self:changeState('up',true)
        self:moveBy( 0, -2 )
    end
    if pd.buttonIsPressed( pd.kButtonRight ) and x < screenSize["width"]-7 - self:getSize() then
      self:changeState('right',true)
      self:moveBy( 2, 0 )
    end
    if pd.buttonIsPressed( pd.kButtonDown )  and y < screenSize["height"]-7 - self:getSize() then
      self:changeState('down',true)
      self:moveBy( 0, 2 )
    end
    if pd.buttonIsPressed( pd.kButtonLeft ) and x > 0 then
        self:changeState('left',true)
        self:moveBy( -2, 0 )
    end

    -- Mise à jour de l'image du sprite hero
    self:updateAnimation()
  end

