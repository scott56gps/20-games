function love.load()
  Message = "Hola, mundo!"
  WindowWidth = 800
  WindowHeight = 600
  PaddleThickness = 12
  PaddleHeight = 82
  MessageStartPosition = (WindowWidth / 2) - (string.len(Message) * 4)
  InitialPaddleYPosition = (WindowHeight / 2) - (PaddleHeight / 2)
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
  if love.keyboard.isDown("space") then
    InitialPaddleYPosition = InitialPaddleYPosition - 1
  end
end

function love.draw()
  love.graphics.print(Message, MessageStartPosition, 300)
  love.graphics.arc("line", "closed", 200, 300, 12, 6, 12, 30)
  love.graphics.rectangle("fill", 0, InitialPaddleYPosition, PaddleThickness, PaddleHeight)
  love.graphics.rectangle("fill", WindowWidth - PaddleThickness, InitialPaddleYPosition, PaddleThickness, PaddleHeight)
end
