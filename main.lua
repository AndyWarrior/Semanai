-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- include the Corona "storyboard" module
local storyboard = require "storyboard"

local topY = display.screenOriginY --Numerical value for the top of the screen
local rightX = display.contentWidth - display.screenOriginX --Numerical value for the right of the screen
local bottomY = display.contentHeight - display.screenOriginY --Numerical value for the bottom of the screen
local leftX = display.screenOriginX --Numerical value for the left of the screen
local screenW = rightX - leftX --Numerical value for the width of the screen
local screenH = bottomY - topY --Numerical value for the height of the screen





function startGame()
	boton_inicio:removeEventListener("tap", startGame)
	boton_manual:removeEventListener("tap", showManual)
	boton_creditos:removeEventListener("tap", showCredits)

	menu:removeSelf()
	menu = nil

	boton_inicio:removeSelf()
	boton_inicio = nil

	boton_manual:removeSelf()
	boton_manual = nil

	boton_creditos:removeSelf()
	boton_creditos = nil

	local options =
	{
	  effect = "fade",
	  time = 500,
	}
	
	storyboard.gotoScene("mainGame", options)
	storyboard.removeScene("main")
end

function showManual()
	boton_inicio:removeEventListener("tap", startGame)
	boton_manual:removeEventListener("tap", showManual)
	boton_creditos:removeEventListener("tap", showCredits)
	
	manual_page = display.newImageRect("pantalla_manual.png", screenW, screenH)
	manual_page.x = screenW/2
	manual_page.y = screenH/2
	manual_page:addEventListener("tap", hideManual)
end

function hideManual()
	manual_page:removeEventListener("tap", hideManual)
	manual_page:removeSelf()
	manual_page = nil

	boton_inicio:addEventListener("tap", startGame)
	boton_manual:addEventListener("tap", showManual)
	boton_creditos:addEventListener("tap", showCredits)
end

function showCredits()
	boton_inicio:removeEventListener("tap", startGame)
	boton_manual:removeEventListener("tap", showManual)
	boton_creditos:removeEventListener("tap", showCredits)
	
	credits_page = display.newImageRect("pantalla_creditos.png", screenW, screenH)
	credits_page.x = screenW/2
	credits_page.y = screenH/2
	credits_page:addEventListener("tap", hideCredits)
end

function hideCredits()
	credits_page:removeEventListener("tap", hideCredits)
	credits_page:removeSelf()
	credits_page = nil

	boton_inicio:addEventListener("tap", startGame)
	boton_manual:addEventListener("tap", showManual)
	boton_creditos:addEventListener("tap", showCredits)
end

menu = display.newImageRect("menu.png", screenW, screenH)
menu.x = screenW/2
menu.y = screenH/2

boton_inicio = display.newImageRect("boton_inicio.png", screenW/1.5, 200)
boton_inicio.x = screenW/2
boton_inicio.y = 450
boton_inicio:addEventListener("tap", startGame)

boton_manual = display.newImageRect("boton_manual.png", screenW/1.5, 200)
boton_manual.x = screenW/2
boton_manual.y = 750
boton_manual:addEventListener("tap", showManual)

boton_creditos = display.newImageRect("boton_creditos.png", screenW/1.5, 200)
boton_creditos.x = screenW/2
boton_creditos.y = 1050
boton_creditos:addEventListener("tap", showCredits)


