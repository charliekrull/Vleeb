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
PADDLE_SPEED = 350



--[[
    Runs when the game starts up, once
]]

function love.load()
    --use nearest neighbor filtering on upscaling and downscaling
    love.graphics.setDefaultFilter('nearest', 'nearest')

    --set window title of application
    love.window.setTitle("Vleeb")

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
    net = Paddle((VIRTUAL_WIDTH / 2) - 2, VIRTUAL_HEIGHT - 20, 5, 20 )
    

    --initialize ball
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4, 250)

    --randomly determine first servingPlayer
    servingPlayer = math.random(1, 2)


    --game state variable used to transition between different parts of the game
    --my very firstest one
    gameState = 'start'
end

--[[
    Runs every frame, with "dt" passed in, our delta in seconds since the last frame, which LOVE2D supplies us.
]]

function love.update(dt)
    if gameState == 'serve' then
        --before switching to play, initialize ball's velocity based on who scored
        ball.dy = 0
        if servingPlayer == 1 then
            ball.dx = math.random(100, 400)
        else
            ball.dx = -math.random(100, 400)
        end
    
    elseif gameState == 'play' then
        --detect ball collision with paddles, reversing dy if true and slightly increasing it
        if ball:collides(player1) then
            ball.dy = -ball.dy * 1.03
            ball.y = player1.y - 4
        end

        if ball:collides(player2) then
            ball.dy = -ball.dy * 1.03
            ball.y = player2.y - 4
        end

        --detect net collision. note that net is a Paddle that cannot be moved. reflects ball's dx when colliding
        if ball:collides(net) then
            if ball.dx < 0 then
                ball.x = net.x + net.width
            elseif ball.dx > 0 then
                ball.x = net.x - 4

            elseif ball.dx == 0 then
                ball.dx = math.random(-19, 10)    
            end

            ball.dx = -ball.dx
        end

        --detect screen boundary collisions and reverse relevant axis
        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
        end

        if ball.y >= VIRTUAL_HEIGHT - 4 then
            if ball.x < VIRTUAL_WIDTH / 2 then --player 2 scores
                servingPlayer = 1
                player2Score = player2Score + 1
                ball:reset()
                gameState = 'serve'

            elseif ball.x >= VIRTUAL_WIDTH / 2 then --player 1 scores
                servingPlayer = 2
                player1Score = player1Score + 1
                ball:reset()
                gameState = 'serve'
            end
        end

        if ball.x >= VIRTUAL_WIDTH - 4 then
            ball.x = VIRTUAL_WIDTH - 4
            ball.dx = -ball.dx
        end

        if ball.x <= 0 then
            ball.x = 0
            ball.dx = -ball.dx
        end

    end


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
            gameState = 'serve'
        elseif gameState == 'serve' then
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
    if gameState == 'start' then
        love.graphics.printf("Press Enter to Start!", 0, 45, VIRTUAL_WIDTH, 'center')    
    
    elseif gameState == 'serve' then
        serveString = "Player ".. tostring(servingPlayer)..' serve'
        love.graphics.printf(serveString, 0, 45, VIRTUAL_WIDTH, 'center')
    end
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
    net:render()

    --render ball
    ball:render()


    --uncomment to display FPS
    --displayFPS()

    push:apply('end') --stop rendering at virtual resolution
end

function displayFPS()
    --simple FPS display across all states
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print(tostring(love.timer.getFPS()).." FPS", 10, 10)
end