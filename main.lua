--Vleeb
--It's Pong, but Volleyball instead of ping pong.

push = require 'push'

Class = require "class"

require "Ball"
require "Paddle"


WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

--speed at which paddle moves, multiplied by dt in update
PADDLE_SPEED = 200



--[[
    Runs when the game starts up, once
]]

function love.load()
    --use nearest neighbor filtering on upscaling and downscaling
    love.graphics.setDefaultFilter('nearest', 'nearest')

    --Seed the RNG using current time
    math.randomseed(os.time())

    --retro font object
    smallFont = love.graphics.newFont('font.ttf', 8)

    --larger font for displaying the score
    scoreFont = love.graphics.newFont('font.ttf', 32)

    --set LOVE2D's active font to the smallFont object
    love.graphics.setFont(smallFont)

    --initialize virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    --initialize score variables
    player1Score = 0
    player2Score = 0

    --initialize paddles
    player1 = Paddle(50, VIRTUAL_HEIGHT - 20, 20, 5, 0, VIRTUAL_WIDTH/2)
    player2 = Paddle(VIRTUAL_WIDTH - 50, VIRTUAL_HEIGHT - 20, 20, 5, VIRTUAL_WIDTH/2, VIRTUAL_WIDTH)
    

    --initialize ball
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4, 20)

    --game state variable used to transition between different parts of the game
    --my very firstest one
    gameState = 'start'
end

--[[
    Runs every frame, with "dt" passed in, our delta in seconds since the last frame, which LOVE2D supplies us.
]]

function love.update(dt)
    --player 1 movement
    if love.keyboard.isDown('a') then
        player1.dx = -PADDLE_SPEED

    elseif love.keyboard.isDown('d') then
        player1.dx = PADDLE_SPEED
        
    else
        player1.dx = 0
    end

    --player 2 movement
    if love.keyboard.isDown('left') then
        player2.dx = -PADDLE_SPEED

    elseif love.keyboard.isDown('right') then
        player2.dx = PADDLE_SPEED

    else
        player2.dx = 0
    end

    if gameState == 'play' then
        ball:update(dt)
    end

    player1:update(dt)
    player2:update(dt)

end


--[[
    Keyboard handling, called by LOVE2D each frame;
    passes in the key we pressed so we can access.
]]

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        else
            gameState = 'start'

            --start ball's position in the middle of the screen
            ball:reset()
        end    
    
    end
end

--[[
    Called after update by LOVE2D, used to draw to screen
]]

function love.draw()
    push:apply('start') --begin rendering at virtual resolution

    love.graphics.clear(0.16, 0.18, 0.20, 1.0) --clear the screen greeaayayey
    
    --Title on court
    love.graphics.setFont(smallFont)
    love.graphics.printf("VLEEB!", 0, 30, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(gameState, 0, 45, VIRTUAL_WIDTH, 'center')

    --draw score to left and right side of screen
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), (VIRTUAL_WIDTH / 2) - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), (VIRTUAL_WIDTH / 2) + 30, VIRTUAL_HEIGHT / 3)
    
    --paddles are rectangles drawn on the screen, as is the ball
    --render left paddle, player 1
    player1:render()

    --render right paddle, player 2
    player2:render()

    --render net
    love.graphics.rectangle('line', (VIRTUAL_WIDTH / 2) - 2, VIRTUAL_HEIGHT - 20, 5, 20)

    --render ball
    ball:render()

    push:apply('end') --stop rendering at virtual resolution
end