push = require 'push'
Class = require 'Class'

require 'Paddle'
require 'Ball'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest') --change rendering to look pixelized

	love.window.setTitle('Pong')

	math.randomseed(os.time())

	-- retro looking font we can use for anything
	smallFont = love.graphics.newFont('font.ttf', 8)
	scoreFont = love.graphics.newFont('font.ttf', 32)

	
	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		fullscreen = false,
		resizable = false,
		vsync = true
	})

	player1Score = 0
	player2Score = 0

	-- player1Y = 30
	-- player2Y = VIRTUAL_HEIGHT - 50

	-- ballX = VIRTUAL_WIDTH / 2 - 2
	-- ballY = VIRTUAL_HEIGHT / 2 - 2

	-- -- ball mouvement velocity
	-- ballDX = math.random(2) == 1 and 100 or -100
	-- ballDY = math.random(-50, 50) * 1.5

	player1 = Paddle(10, 30, 5, 20)
	player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)
	
	ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

	gameState = 'start'

end

function love.update(dt)
	--player 1 movement
	if love.keyboard.isDown('z') then
		player1.dy = -PADDLE_SPEED
	elseif love.keyboard.isDown('s') then
		player1.dy = PADDLE_SPEED
	else
		player1.dy = 0
	end

	--player 2 movemont
	if love.keyboard.isDown('up') then
		player2.dy = -PADDLE_SPEED
	elseif love.keyboard.isDown('down') then
		player2.dy = PADDLE_SPEED
	else
		player2.dy = 0
	end

	if gameState == 'play' then
		ball:update(dt)
	end
	player1:update(dt)
	player2:update(dt)
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	elseif key == 'enter' or key == 'return' then
		if gameState == 'start' then
			gameState = 'play'
		else
			gameState = 'start'
			
			ball:reset()
		end
	end
end

function love.draw()
	push:apply('start')
	
	--color the toltal view
	love.graphics.clear(40/255, 45/255, 52/255, 255/255)


	love.graphics.setFont(smallFont)

	if gameState == 'start' then
		love.graphics.printf('Hello start State!', 0, 20, VIRTUAL_WIDTH, 'center')
	else
		love.graphics.printf('Hello play State!', 0, 20, VIRTUAL_WIDTH, 'center')
	end

	love.graphics.setFont(scoreFont)
	love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 -50, VIRTUAL_HEIGHT/3)
	love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT/3)

	--render first paddle( left side) ('fill/', x, y, width, height)
	-- love.graphics.rectangle('fill', 10, player1Y, 5, 20)
	player1:render()
		

	-- love.graphics.rectangle('fill', VIRTUAL_WIDTH -10, player2Y , 5, 20)
	player2:render()

	-- ball
	-- love.graphics.rectangle('fill', ballX, ballY , 4, 4)
	ball:render()


	displayFPS()

	push:apply('end')
end
	
function displayFPS()
	love.graphics.setFont(smallFont)
	love.graphics.setColor(0, 255, 0, 255)
	love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end
