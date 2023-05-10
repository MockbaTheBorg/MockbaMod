-- Open Libraries -------------------------------
local lib = require 'sdl2.init'
local SDL = lib.sdl
local TTF = lib.ttf
local ffi = require 'ffi'
local C = ffi.C

-- Default variables ----------------------------
local running	= 100
local buttons	= {}
local event		= ffi.new('SDL_Event')
local finger	= ffi.new('SDL_TouchFingerEvent')
local width		= 1280
local height	= 800
local fontSize	= 60

-- Initializations ------------------------------
if SDL.Init(SDL.INIT_VIDEO) == -1 then
	error("Cannot initialize SDL")
end

local win = SDL.CreateWindow("Window",0,0,width,height,0)
if not win then
	error("Cannot create window")
end
local rdr = SDL.CreateRenderer(win, -1, SDL.RENDERER_ACCELERATED)
if not rdr then
	error("Cannot create renderer")
end
local ttf = TTF.Init()
if ttf == nil then
	error("Cannot initialize TTF")
end
local fnt = TTF.OpenFont("Fonts/Force.ttf", fontSize)
if fnt == nil then
	error("Cannot open font file")
end

-- App functions --------------------------------
local function addButton(r,b,x,y,w,h,t,c)
	-- needs global buttons{}
	c = c or t
	buttons[b] = {x=x,y=y,w=w,h=h,text=t,caption=c}
end

function drawButtons(r,b)
	for idx,btn in ipairs(b) do
	
		local rect = ffi.new('SDL_Rect')
		rect.x = btn.x
		rect.y = btn.y
		rect.w = btn.w
		rect.h = btn.h

		local color = ffi.new('SDL_Color')
		color.r = 0xff
		color.g = 0xff
		color.b = 0xff
		color.a = 0xff

		SDL.SetRenderDrawColor(r, 255, 255, 255, 255)
		SDL.RenderDrawRect(r, rect)

		rect.x = rect.x + 4
		rect.w = rect.w - 8
		local srf = TTF.RenderUTF8_Blended(fnt, btn.caption, color)
		local txt = SDL.CreateTextureFromSurface(r, srf)
		SDL.RenderCopy(r,txt,nil,rect)
	end
end

local function hitButton(r,x,y)
	local rect = ffi.new('SDL_Rect')

	x = math.floor(x * width)
	y = math.floor(y * height)
	for idx,btn in ipairs(buttons) do
		if x > btn.x and x < (btn.x + btn.w) then
			if y > btn.y and y < (btn.y + btn.h) then
				rect.x = btn.x
				rect.y = btn.y
				rect.w = btn.w
				rect.h = btn.h
				SDL.SetRenderDrawColor(r, 64, 128, 128, 255)
				SDL.RenderFillRect(r, rect)
				drawButtons(r, buttons)
				SDL.RenderPresent(r)
				SDL.Delay(100)
				result = idx
			end
		end
	end
	return result
end
	
-- Collect list of apps -------------------------
local apps = {}
local handle = io.popen("cat /dev/shm/.mmPath")
local mmPath = handle:read("*l")
handle:close()
local f = assert(io.popen ("ls -p " .. mmPath .. "/Apps | grep -v /"))
for line in f:lines() do
	table.insert(apps, line)
end
f:close()

table.insert(apps, 'MPC')

-- Main program ---------------------------------

SDL.RenderClear(rdr)

local bx = 50
local by = 20
local bWidth = 300
local bHeight = 62

for idx,app in ipairs(apps) do
	addButton(rdr,idx,bx,by,bWidth,bHeight,app)
	by = by + 80
end

drawButtons(rdr,buttons)
SDL.RenderPresent(rdr)

local app = "MPC"
while running > 0 do
	if SDL.PollEvent(event) ~= 0 then
		if event.type == SDL.KEYDOWN then
			break
		end
		if event.type == SDL.FINGERDOWN then
			finger = event.tfinger
			local button = hitButton(rdr,finger.x,finger.y)
			if button ~= nil then
				app = buttons[button].text
				break
			end
		end
	end
	running = running - 1
	SDL.Delay(200)
end
print(app)

SDL.DestroyWindow(win)
SDL.Quit()
