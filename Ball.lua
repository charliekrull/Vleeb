--a ball for a pong game. it bounces and pings and pongs and has gravity

Ball = Class{}

function Ball:init(x, y, width, height, gravity)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.gravity = gravity

    --x and y velocities
    self.dx = 0
    self.dy = 0

end

function Ball:collides(paddle)
    --determine if ball collides with paddle, naturally. Does so by checking if the edge of ball is beyond the opposite edge of paddle
    --check if left edge of either is farther to the right than the right edge of the other
    if self.x > paddle.x + paddle.width or paddle.x> self.x + self.width then
        return false

    end

    --then check to see if the bottom edge of either is higher than the top edge of the other
    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
        return false
    end

    --the the above aren't true, they're overlapping
    return true
end

--reset ball to center of screen
function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
end

--applies velocity to position scaled by dt
function Ball:update(dt)
    self.dy = self.dy + self.gravity * dt --apply gravity
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

--draw the ball
function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end