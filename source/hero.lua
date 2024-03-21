import "libraries/AnimatedSprite/AnimatedSprite.lua"

local pd <const> = playdate
local gfx <const> = pd.graphics

-- Classe hero qui permet de definir le comportement d'un hero
class("Hero").extends(AnimatedSprite)

  local xConst <const> = 121
  local yConst <const> = 162
  local zConst <const> = 10000


  -- Initialisation d'un héro, toujours fais quand on créée un nouveau héro
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

  -- Faire revivre un hero
  function Hero:raz()
    local goalX = math.random(40, 360)
    local goalY = math.random(40, 200)
    --need a global var!
    self:moveTo(goalX, goalY)
  end

  -- Mise à jour du sprite hero
  function Hero:update()

    -- Get the current position
    local x, y = self:getPosition()

    -- Réactions quand on appuie sur un bouton
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

