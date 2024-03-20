local gfx <const> = playdate.graphics

class('Healthbar').extends(gfx.sprite)

function Healthbar:init(x, y, maxHealth)
	Healthbar.super.init(self) --overriding of the parent easingFunction
	self.maxHealth = maxHealth
	self.health = maxHealth
	self:moveTo(x, y)
	self:updateHealth(maxHealth)
	self:add()
end

function Healthbar:updateHealth(newHealth)
	local maxWidth = 100
	local height = 5
	local healthbarWidth = (newHealth / self.maxHealth) * maxWidth
	local healthbarImage = gfx.image.new(maxWidth, height)
	gfx.pushContext(healthbarImage)
		gfx.fillRect(0, 0, healthbarWidth, height)
	gfx.popContext()
	self:setImage(healthbarImage)
end

function Healthbar:damage(amount)
	self.health -= amount
	if self.health <= 0 then
		self.health = 0
		sounds['playerDeath']:play()
		os.exit()
	end
	self:updateHealth(self.health)
	print("Damage:"..self.health)
end

function Healthbar:heal(amount)
		self.health += amount
		if self.health > self.maxHealth then
				self.health = self.maxHealth
		end
		self:updateHealth(self.health)
		print("Healed:"..self.health)
end
