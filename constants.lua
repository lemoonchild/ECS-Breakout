local Constants = {}

Constants.WINDOW_WIDTH = 800
Constants.WINDOW_HEIGHT = 600

Constants.PADDLE_SPEED = 400
Constants.PADDLE_WIDTH = 100
Constants.PADDLE_HEIGHT = 15

Constants.BALL_SPEED = 250
Constants.BALL_SIZE = 12
Constants.BALL_SPEEDUP = 1.05

Constants.BRICK_ROWS = 5
Constants.BRICK_COLS = 9
Constants.BRICK_WIDTH = 80
Constants.BRICK_HEIGHT = 25
Constants.BRICK_PADDING = 8
Constants.BRICK_TOP_OFFSET = 50

Constants.BRICK_COLORS = {
    {r = 0.05, g = 0.1,  b = 0.35},
    {r = 0.1,  g = 0.2,  b = 0.5},
    {r = 0.15, g = 0.35, b = 0.7},
    {r = 0.3,  g = 0.55, b = 0.85},
    {r = 0.55, g = 0.75, b = 0.95},
}

Constants.BALL_COLOR = {r = 0.6, g = 0.2, b = 0.8}
Constants.PADDLE_COLOR = {r = 1, g = 1, b = 1}

return Constants
