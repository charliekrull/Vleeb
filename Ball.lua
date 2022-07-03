--a ball for a pong game. it bounces and pings and pongs and has gravity

Ball = Class{}

function Ball:init(x, y, width, height, gravity)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.gravity = gravity

    --x and y velocities
    self.dy = math.random(-100, 100)
    self.dx = math.random(-50, 50)

end

--reset ball to center of screen
function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
    self.dy = math.random(-100, 100)
    self.dx = math.random(-50, 50)
end

--applies velocity to position scaled by dt
function Ball:update(dt)
    self.dy = self.dy + self.gravity --apply gravity
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

--draw the ball
function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end