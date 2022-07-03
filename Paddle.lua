--paddle in a pong game. moves and eventually collides
Paddle = Class{}

function Paddle:init(x, y, width, height, min_x, max_x)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.min_x = min_x
    self.max_x = max_x

    self.dx = 0
end

function Paddle:update(dt)
    --clamp to respective side
    if self.dx < 0 then
        self.x = math.max(self.min_x, self.x + self.dx * dt)

    else
        self.x = math.min(self.max_x - self.width, self.x + self.dx * dt)
    end
end

function Paddle:render()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end