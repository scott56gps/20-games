local function makeBeep(freq, duration, volume)
  local rate = 44100
  local samples = math.floor(rate * duration)
  local data = love.sound.newSoundData(samples, rate, 16, 1)

  for i = 0, samples - 1 do
    local t = i / rate
    local wave = (math.sin(2 * math.pi * freq * t) >= 0) and 1 or -1
    local fade = 1 - (i / samples)
    data:setSample(i, wave * volume * fade)
  end

  return love.audio.newSource(data)
end

function love.load()
  Message = "Hola, mundo!"
  WindowWidth = 800
  WindowHeight = 600
  WindowXMidpoint = WindowWidth / 2
  WindowYMidpoint = WindowHeight / 2

  local windowIcon = love.image.newImageData("star-icon.png")
  love.window.setMode(WindowWidth, WindowHeight)
  love.window.setTitle("Pong!")
  love.window.setIcon(windowIcon)
  Font = love.graphics.newFont(27)

  local ballXVelocity = 110
  local ballYVelocity = 80
  Ball = { x = WindowXMidpoint, y = 300, radius = 12, dx = ballXVelocity, dy = ballYVelocity }
  BallIsMovingLeft = true

  local paddleHeight = 82
  local paddleThickness = 12
  local initialPaddleDy = 130
  local initialPaddleYPosition = (WindowHeight / 2) - (paddleHeight / 2)
  LeftPaddle = { x = 0, y = initialPaddleYPosition, dy = initialPaddleDy,
                 width = paddleThickness, height = paddleHeight }
  RightPaddle = { x = WindowWidth - paddleThickness, y = initialPaddleYPosition, dy = initialPaddleDy,
                  width = paddleThickness, height = paddleHeight }

  LeftPlayerScore = 0
  RightPlayerScore = 0
  LeftPlayerScoreXPosition = WindowXMidpoint - 30
  RightPlayerScoreXPosition = WindowXMidpoint + 30

  -- Sound
  Sounds = {}

  Sounds.paddle = makeBeep(440, 0.06, 0.3)
  Sounds.wall = makeBeep(220, 0.06, 0.3)
  Sounds.score = makeBeep(110, 0.25, 0.3)
end

function love.keypressed(key)
  if key == "q" then
    love.event.quit()
  end
end

local function ballHitsPaddle(ball, paddle)
  return ball.x + ball.radius > paddle.x
      and ball.x - ball.radius < paddle.x + paddle.width
      and ball.y + ball.radius > paddle.y
      and ball.y - ball.radius < paddle.y + paddle.height
end

local function ballHitsTopWall(ball)
  return ball.y - ball.radius <= 0
end

local function ballHitsBottomWall(ball)
  return ball.y + ball.radius >= WindowHeight
end

local function ballLeavesLeftWall(ball)
  return ball.x <= 0
end

local function ballLeavesRightWall(ball)
  return ball.x >= WindowWidth
end

function love.update(dt)
  if BallIsMovingLeft == true then
    Ball.x = Ball.x + (-Ball.dx * dt)
    Ball.y = Ball.y + (Ball.dy * dt)
  end
  if BallIsMovingLeft == false then
    Ball.x = Ball.x + (Ball.dx * dt)
    Ball.y = Ball.y + (Ball.dy * dt)
  end
  if ballHitsPaddle(Ball, LeftPaddle) then
    BallIsMovingLeft = false
  end
  if ballHitsPaddle(Ball, RightPaddle) then
    BallIsMovingLeft = true
  end
  if ballHitsTopWall(Ball) then
    Ball.y = Ball.radius
    Ball.dy = math.abs(Ball.dy)
  end
  if ballHitsBottomWall(Ball) then
    Ball.y = WindowHeight - Ball.radius
    Ball.dy = -math.abs(Ball.dy)
  end
  if ballLeavesLeftWall(Ball) then
    RightPlayerScore = RightPlayerScore + 1
    Ball.x = WindowXMidpoint
    Ball.y = WindowYMidpoint
    BallIsMovingLeft = false
  end
  if ballLeavesRightWall(Ball) then
    LeftPlayerScore = LeftPlayerScore + 1
    Ball.x = WindowXMidpoint
    Ball.y = WindowYMidpoint
    BallIsMovingLeft = true
  end
  if love.keyboard.isDown("w") then
    if LeftPaddle.y >= 0 then
      LeftPaddle.y = LeftPaddle.y + (-LeftPaddle.dy * dt)
      LeftPaddle.dy = math.abs(LeftPaddle.dy)
    end
  end
  if love.keyboard.isDown("s") then
    if (LeftPaddle.y + LeftPaddle.height) <= WindowHeight then
      LeftPaddle.y = LeftPaddle.y + (LeftPaddle.dy * dt)
    end
  end
  if love.keyboard.isDown("up") then
    if RightPaddle.y >= 0 then
      RightPaddle.y = RightPaddle.y + (-RightPaddle.dy * dt)
      RightPaddle.dy = math.abs(RightPaddle.dy)
    end
  end
  if love.keyboard.isDown("down") then
    if (RightPaddle.y + RightPaddle.height) <= WindowHeight then
      RightPaddle.y = RightPaddle.y + (RightPaddle.dy * dt)
    end
  end
end

function love.draw()
  love.graphics.setFont(Font)
  local leftText = tostring(LeftPlayerScore)
  love.graphics.print(leftText, LeftPlayerScoreXPosition - Font:getWidth(leftText), 15)
  love.graphics.print(RightPlayerScore, RightPlayerScoreXPosition, 15)

  -- Draw the divider line
  love.graphics.line(WindowXMidpoint, 0, WindowXMidpoint, WindowHeight)
  love.graphics.arc("line", "closed", Ball.x, Ball.y, Ball.radius, 6, 12, 30)
  love.graphics.rectangle("fill", LeftPaddle.x, LeftPaddle.y, LeftPaddle.width, LeftPaddle.height)
  love.graphics.rectangle("fill", RightPaddle.x, RightPaddle.y, RightPaddle.width, RightPaddle.height)
end
