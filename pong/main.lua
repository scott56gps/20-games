function love.load()
  Message = "Hola, mundo!"
  WindowWidth = 800
  WindowHeight = 600
  PaddleThickness = 12
  PaddleHeight = 82
  MessageStartPosition = (WindowWidth / 2) - (string.len(Message) * 4)
  InitialPaddleYPosition = (WindowHeight / 2) - (PaddleHeight / 2)
  BallStartXPosition = 200
  BallStartYPosition = 300
  BallIsMovingLeft = true
  BallVelocity = 3
  local windowIcon = love.image.newImageData("star-icon.png")
  love.window.setMode(WindowWidth, WindowHeight)
  love.window.setTitle("Pong!")
  love.window.setIcon(windowIcon)
end

function love.keypressed(key)
  if key == "q" then
    love.event.quit()
  end
end

function love.update(dt)
  if BallIsMovingLeft == true then
    BallStartXPosition = BallStartXPosition - BallVelocity
  end
  if BallIsMovingLeft == false then
    BallStartXPosition = BallStartXPosition + BallVelocity
  end
  if BallStartXPosition <= 0 then
    BallIsMovingLeft = false
  end
  if BallStartXPosition >= WindowWidth then
    BallIsMovingLeft = true
  end
  if love.keyboard.isDown("space") or love.keyboard.isDown("up") then
    InitialPaddleYPosition = InitialPaddleYPosition - 1
  end
  if love.keyboard.isDown("down") then
    InitialPaddleYPosition = InitialPaddleYPosition + 1
  end
end

function love.draw()
  love.graphics.print(Message, MessageStartPosition, 300)
  love.graphics.arc("line", "closed", BallStartXPosition, BallStartYPosition, 12, 6, 12, 30)
  love.graphics.rectangle("fill", 0, InitialPaddleYPosition, PaddleThickness, PaddleHeight)
  love.graphics.rectangle("fill", WindowWidth - PaddleThickness, InitialPaddleYPosition, PaddleThickness, PaddleHeight)
end
