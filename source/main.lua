import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "player"
import "coin"
import "well"
import "healthbar"

import "tools"

local pd <const> = playdate
local gfx <const> = pd.graphics

local snd = playdate.sound

playdate.display.setRefreshRate(70) -- Refresh rate

local playerSprite = nil

local playerSpeed = 4

local playTimer = nil
local playTime = 30 * 1000

local coinSprite = nil
local score = 0

minX = 0
maxX = 400
minY = 0
maxY = 240

ballX = maxX / 2
ballY = maxY / 2
ballR = 15
velX = 2
velY = 2

screenSize = { width = 400, height = 240, gridWidth = 20, hudHeight = 20 }

sounds = {
  coinEaten  = snd.sampleplayer.new( "audio/playerpain.wav" ),
  playerPain = snd.sampleplayer.new( "audio/playerdeath.wav" ),
  playerDeath = snd.sampleplayer.new( "audio/playerdeath.wav" ),
  background = snd.sampleplayer.new( "audio/RawrTheme.wav"  )
}

local lastCoinMoveTime = 0


local function resetTimer()
  playTimer = playdate.timer.new(playTime, playTime, 0, playdate.easingFunctions.linear)
end

-- Function that saves game data
function saveGameData()
    -- Save game data into a table first
    local gameData = {
        currentScore = score
    }
    -- Serialize game data table into the datastore
    playdate.datastore.write(gameData)
end


sounds['background']:play(10)


function KeepInBoundsX(x)
  if ( x < 0 ) then x = 0 end

  if ( x > screenSize["width"] - screenSize["gridWidth"] ) then
    x = screenSize["width"] - screenSize["gridWidth"]
  end
  return x
end
function KeepInBoundsY(y)

  if ( y < screenSize["hudHeight"] ) then y = screenSize["hudHeight"] end

  if ( y > screenSize["height"] - screenSize["gridWidth"] ) then
    y = screenSize["height"] - screenSize["gridWidth"]
  end
  return y
end

local function initialize()
  math.randomseed(playdate.getSecondsSinceEpoch())

  healthSprite = Healthbar(200,15,100)

  wellSprite = Well(20, 120, 2, .1)
  wellSprite2 = Well(40, 140, 2, .1)
  playerSprite = Player()
  playerSprite:add()

  coinSprite = Coin()
  coinSprite2 = Coin()
  coinSprite:add()
  coinSprite2:add()
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

initialize()

function playdate.update()

  wellSprite:add()
  wellSprite2:add()


  -- Déplacement des pièces toutes les 6 secondes
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
  playerSprite:moveTo(-100,-100)
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
    if playdate.buttonIsPressed(playdate.kButtonUp) then
      playerSprite:moveBy(0, -playerSpeed)
    end
    if playdate.buttonIsPressed(playdate.kButtonRight) then
      playerSprite:moveBy(playerSpeed, 0)
    end
    if playdate.buttonIsPressed(playdate.kButtonDown) then
      playerSprite:moveBy(0, playerSpeed)
    end
    if playdate.buttonIsPressed(playdate.kButtonLeft) then
      playerSprite:moveBy(-playerSpeed, 0)
    end

    if(coinSprite:alphaCollision(playerSprite)) then
      sounds['coinEaten']:play()
      coinSprite:moveCoin(coinSprite2)
      score = score + 1
      healthSprite:heal(15)
    end
    if(coinSprite2:alphaCollision(playerSprite)) then
      sounds['coinEaten']:play()
      coinSprite2:moveCoin(coinSprite)
      score = score + 1
      healthSprite:heal(15)
    end
    if(wellSprite:alphaCollision(playerSprite)) then
      sounds['playerPain']:play()
      wellSprite:moveWell(wellSprite2, calculateNewPosition1)
      playerSprite:raz()
      healthSprite:damage(15)
    end
    if(wellSprite2:alphaCollision(playerSprite)) then
      sounds['playerPain']:play()
      wellSprite2:moveWell(wellSprite, calculateNewPosition2)
      playerSprite:raz()
      healthSprite:damage(15)
    end
  end


  gfx.sprite.update()
  pd.timer.updateTimers()
  -- pd.drawFPS(380, 10)
  gfx.drawText("Time: " .. math.ceil(playTimer.value/1000), 5, 5)
  gfx.drawText("Score: " .. score, 320, 5)
  gfx.drawText("Health: ", 90, 5)
end
