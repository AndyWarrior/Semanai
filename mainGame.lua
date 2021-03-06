display.setStatusBar( display.HiddenStatusBar )

system.activate("multitouch")

local movieclip = require ("movieclip")
local storyboard = require "storyboard"
local scene = storyboard.newScene()

local topY = display.screenOriginY --Numerical value for the top of the screen
local rightX = display.contentWidth - display.screenOriginX --Numerical value for the right of the screen
local bottomY = display.contentHeight - display.screenOriginY --Numerical value for the bottom of the screen
local leftX = display.screenOriginX --Numerical value for the left of the screen
local screenW = rightX - leftX --Numerical value for the width of the screen
local screenH = bottomY - topY --Numerical value for the height of the screen

local hits = 0
local cycles = 0
local mistakes = 0
local handsMoving = 1

function startGame()
	timer.performWithDelay( 400, playMusic )
	Runtime:addEventListener( "enterFrame", moveHands )

end

function showElements()
	background = display.newImageRect("fondo.png", screenW, screenH)
	background.x = screenW/2 + leftX
	background.y = screenH/2 + topY

	myText = display.newText( "Repeticiones", 50, 40, native.systemFont, 48  )
	hits_text = display.newText( "0 (0)", 140, 90, native.systemFont, 48  )
	myText2 = display.newText( "Errores", 500, 40, native.systemFont, 48  )
	mistakes_text = display.newText( "0", 565, 90, native.systemFont, 48  )

	person = display.newImageRect("persona.png", screenW, 1100)
	person.x = leftX + screenW/2
	person.y = bottomY - person.height/2
	person:addEventListener("tap", tapAction)

	blow_text = display.newText( "¡Sopla 2 veces en su boca!", 108, 1100, native.systemFont, 44  )
	blow_text:setFillColor(255,0,0)
	blow_text.alpha = 0

	heart = display.newImageRect("corazon.png", 140, 140)
	heart.x = 400
	heart.y = screenH/1.6

	upper_line = display.newLine( leftX, 700, rightX, 700)
	lower_line = display.newLine( leftX, 950, rightX, 950)

	upper_line:setColor(0,255,0)
	upper_line.strokeWidth = 8
	lower_line.strokeWidth = 8
	lower_line:setColor(0,255,0)

	hands ={}

	hands[1] = display.newImageRect("mano.png", 200, 200)
	hands[1].x = rightX + hands[1].width
	hands[1].y = screenH/1.6


	hands[2] = display.newImageRect("mano.png", 200, 200)
	hands[2].x = rightX + (3 * hands[1].width)
	hands[2].y = screenH/1.6


	hands[3] = display.newImageRect("mano.png", 200, 200)
	hands[3].x = rightX + (5 * hands[1].width)
	hands[3].y = screenH/1.6

	hands[4] = display.newImageRect("mano.png", 200, 200)
	hands[4].x = rightX + (7 * hands[1].width)
	hands[4].y = screenH/1.6

	pulse = display.newImageRect("pulso.png", 400, 300)
	pulse.x = leftX - pulse.width
	pulse.y = screenH/2

	pulseRight()
end

function pulseRight()
	transition.to( pulse, { time=3000, x = 200, onComplete=pulseLeft } )
end

function pulseLeft()
	transition.to( pulse, { time=3000, delay=5000, x = leftX - pulse.width, onComplete=startGame } )
end

function pauseGame()
	--audio.pause()
	handsMoving = 0
	timer.performWithDelay( 6000, resumeGame )
	blow_text.alpha = 1
end

function resumeGame()
	--audio.resume()
	handsMoving = 1
	blow_text.alpha = 0
end

function playMusic()
	backgroundMusic = audio.loadStream( "cancion.mp3" )
	backgroundMusicChannel = audio.play( backgroundMusic, { channel=1, loops=0, onComplete=endGame } )
end

function moveHands()
	--if(handsMoving == 1) then
		for i=1, #hands do
			hands[i].x = hands[i].x - 11.3
			if hands[i].x - hands[i].width/2 < leftX - hands[i].width then
				resetHands(i)
			end

			if(handsMoving == 1) then
				hands[i].alpha = 1
			else
				hands[i].alpha = 0
			end
		end
	--end
end

function resetHands(hand_index)
	if hand_index == 1 then
		hands[hand_index].x = hands[table.maxn(hands)].x + (2 * hands[hand_index].width)
	else
		hands[hand_index].x = hands[hand_index - 1].x  + (2 * hands[hand_index].width)
	end
	
	if hands[hand_index].isVisible == true and handsMoving == 1 then
		mistakes = mistakes + 1
		mistakes_text.text = mistakes
	end
	hands[hand_index].isVisible = true
end

function tapAction(e)
	if(handsMoving == 1) then
		miss = false
		for i=1, #hands do
			--print("click: " .. e.x)
			--print("hand: " .. hands[i].x)
			if hands[i].x >= 300 and hands[i].x <= 500 then
				hits = hits + 1
				if hits == 30 then
					cycles = cycles + 1
					hits = 0
					pauseGame()
				end
				hits_text.text = hits .. " (" .. cycles .. ")"
				hands[i].isVisible = false
				system.vibrate()
				miss = true
			end
		end

		if miss == false then
			mistakes = mistakes + 1
			mistakes_text.text = mistakes
		end
	end
end

function resetGame()
	person:removeEventListener("tap", tapAction)
	Runtime:removeEventListener("enterFrame", moveHands)

	audio.stop()
	audio.dispose(backgroundMusic)
	backgroundMusic = nil

	background:removeSelf()
	background = nil

	myText:removeSelf()
	myText = nil

	hits_text:removeSelf()
	hits_text = nil

	myText2:removeSelf()
	myText2 = nil

	mistakes_text:removeSelf()
	mistakes_text = nil

	person:removeSelf()
	person = nil

	heart:removeSelf()
	heart = nil

	upper_line:removeSelf()
	upper_line = nil

	lower_line:removeSelf()
	lower_line = nil

	for i=1, #hands do
		hands[i]:removeSelf()
		hands[i] = nil
	end

	table.remove(hands)

end

function endGame()
	resetGame()

	end_screen = display.newImageRect("end_screen.png", screenW, screenH)
	end_screen.x = screenW/2
	end_screen.y = screenH/2

	beating_heart = movieclip.newAnim({"corazon1.png","corazon2.png","corazon3.png",},600,600)
	beating_heart.x = screenW/2
	beating_heart.y = screenH/2
	beating_heart:setSpeed(0.10)
	beating_heart:play()
end	


function scene:createScene( event )
	media.playVideo( "video.m4v", true, showElements )
end

function scene:enterScene(event)
end

function scene:exitScene(event)
end

function scene:destroyScene(event)
end

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

return scene