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

  This is the main Lua file for the Rabbit Hole game.
  It contains the core logic and functionality of the game.
]]

-- Core Libraries
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/animation"

-- Third-Party Libraries
import "libraries/AnimatedSprite/AnimatedSprite.lua"

-- Own Modules
import "hero"
import "coin"
import "well"
import "healthbar"
import "tools"

-- Variables
local pd <const> = playdate
local gfx <const> = pd.graphics
local snd = playdate.sound
local hero = nil
local heroSpeed = 4
local playTimer = nil
local playTime = 30 * 1000
local coinSprite = nil
local score = 0
sounds = {
  coinEaten  = snd.sampleplayer.new( "audio/playerpain.wav" ),
  heroPain = snd.sampleplayer.new( "audio/male-pain-sound-effect.wav" ),
  heroDeath = snd.sampleplayer.new( "audio/playerdeath.wav" ),
  background = snd.sampleplayer.new( "audio/RawrTheme.wav"  )
}
local lastCoinMoveTime = 0

-- Constants
local REFRESH_RATE = 70
local HERO_SPEED = 4
local PLAY_TIME = 30 * 1000

-- Global variables
screenSize = { width = 400, height = 240, gridWidth = 44, hudHeight = 44 }
minX = 0
maxX = 400
minY = 0
maxY = 240
ballX = maxX / 2
ballY = maxY / 2
ballR = 15
velX = 2
velY = 2

-- Function to update the game state
function playdate.update()
  gfx.sprite.update()
  playdate.timer.updateTimers()
end

-- Function to reset the game timer
local function resetTimer()
  playTimer = playdate.timer.new(playTime, playTime, 0, playdate.easingFunctions.linear)
end

-- Function to save game data
function saveGameData()
    -- Save game data into a table first
    local gameData = {
        currentScore = score
    }
    -- Serialize game data table into the datastore
    playdate.datastore.write(gameData)
end

-- Function to keep the X coordinate within the game bounds
function KeepInBoundsX(x)
  if ( x < 0 ) then x = screenSize["gridWidth"] end
  if ( x > screenSize["width"]) then
    x = screenSize["width"] - screenSize["gridWidth"]
  end
  print("X:"..x)
  return x
end

-- Function to keep the Y coordinate within the game bounds
function KeepInBoundsY(y)
  if ( y < screenSize["hudHeight"] ) then y = screenSize["hudHeight"] end
  if ( y > screenSize["height"] - screenSize["gridWidth"] ) then
    y = screenSize["height"] - screenSize["gridWidth"]
  end
  print("Y:"..y)
  return y
end

-- Function to initialize the game
local function initialize()
  math.randomseed(playdate.getSecondsSinceEpoch())
  healthSprite = Healthbar(200,15,100)

  -- Definition of animated sprites
  -- https://github.com/Whitebrim/AnimatedSprite/wiki
  -- https://devforum.play.date/t/animated-sprite-helpful-class/1884/20
  local imgtableHero  = gfx.imagetable.new("images/sheet18-table-16-18")
  local imgtableCoin  = gfx.imagetable.new("images/accesories-books-diamons-hair-table-22-22")
  local imgtableWell  = gfx.imagetable.new("images/misc-table-22-22")

  -- Definition of sprite states
  local statesHero    = AnimatedSprite.loadStates("states/hero.json")
  local statesCoin    = AnimatedSprite.loadStates("states/coin.json")
  local statesCoin2   = AnimatedSprite.loadStates("states/coin2.json")
  local statesWell    = AnimatedSprite.loadStates("states/well.json")
  local statesWell2   = AnimatedSprite.loadStates("states/well2.json")

  -- Creation of hero, coin, and well objects
  hero        = Hero(imgtableHero,statesHero,true)
  coinSprite  = Coin(imgtableCoin,statesCoin,false)
  coinSprite2 = Coin(imgtableCoin,statesCoin2,false)
  wellSprite  = Well(imgtableWell,statesWell,true,20, 120, 2, .1)
  wellSprite2 = Well(imgtableWell,statesWell2,true,200, 200, 1, .1)

  coinSprite:moveCoin(coinSprite2)
  coinSprite2:moveCoin(coinSprite)

  local backgroundImage = gfx.image.new("images/background")
  gfx.sprite.setBackgroundDrawingCallback(
    function(x, y, width, height)
      gfx.setClipRect(x, y, width, height)
      backgroundImage:draw(0, 0)
      gfx.clearClipRect()
    end
  )
  resetTimer()
end

-- Function to update the game state
function playdate.update()

  -- Move the coins every 6 seconds
  local currentTime = math.ceil(playTimer.value/1000)
  if currentTime % 6 == 0 and currentTime ~= lastCoinMoveTime then
    coinSprite:moveCoin(coinSprite2)
    coinSprite2:moveCoin(coinSprite)
    -- Update the last move time
    lastCoinMoveTime = currentTime
  end

  if playTimer.value == 0 then
    local backgroundImage = gfx.image.new("images/splashscreen")
    gfx.sprite.setBackgroundDrawingCallback(
      function(x, y, width, height)
        gfx.setClipRect(x, y, width, height)
        backgroundImage:draw(0, 0)
        gfx.clearClipRect()
      end
      )
    hero:moveTo(-100,-100)
    wellSprite:moveTo(-100,-100)
    wellSprite2:moveTo(-100,-100)
    coinSprite:moveTo(-100,-100)
    coinSprite2:moveTo(-100,-100)

    if playdate.buttonJustPressed(playdate.kButtonA) then
      coinSprite:moveCoin(coinSprite2)
      coinSprite2:moveCoin(coinSprite)
      score = 0
      wellSprite:moveTo(200,200)
      wellSprite2:moveTo(300,300)
      initialize()
    end
    gfx.sprite.update()
  else
    if(coinSprite:alphaCollision(hero)) then
      sounds['coinEaten']:play()
      coinSprite:moveCoin(coinSprite2)
      score = score + 1
      healthSprite:heal(15)
    end
    if(coinSprite2:alphaCollision(hero)) then
      sounds['coinEaten']:play()
      coinSprite2:moveCoin(coinSprite)
      score = score + 1
      healthSprite:heal(15)
    end
    if(wellSprite:alphaCollision(hero)) then
      sounds['heroPain']:play()
      wellSprite:moveWell(wellSprite2, calculateNewPosition1)
      healthSprite:damage(15)
      if(healthSprite:getInfo()>=0) then
        hero:death()
        hero:raz()
      else
        hero:death()
        os.exit()
      end
    end
    if(wellSprite2:alphaCollision(hero)) then
      sounds['heroPain']:play()
      wellSprite2:moveWell(wellSprite, calculateNewPosition2)
      healthSprite:damage(15)
      if(healthSprite:getInfo()>=0) then
        hero:death()
        hero:raz()
      else
        hero:death()
        os.exit()
      end
    end
  end

  gfx.sprite.update()
  pd.timer.updateTimers()
  -- pd.drawFPS(380, 10)
  gfx.drawText("Time: " .. math.ceil(playTimer.value/1000), 5, 5)
  gfx.drawText("Score: " .. score, 320, 5)
  gfx.drawText("Health: ", 90, 5)
end

-- Main
playdate.display.setRefreshRate(REFRESH_RATE)
sounds['background']:play(10)
initialize()

