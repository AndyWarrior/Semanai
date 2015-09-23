display.setStatusBar( display.HiddenStatusBar )

system.activate("multitouch")

local topY = display.screenOriginY --Numerical value for the top of the screen
local rightX = display.contentWidth - display.screenOriginX --Numerical value for the right of the screen
local bottomY = display.contentHeight - display.screenOriginY --Numerical value for the bottom of the screen
local leftX = display.screenOriginX --Numerical value for the left of the screen
local screenW = rightX - leftX --Numerical value for the width of the screen
local screenH = bottomY - topY --Numerical value for the height of the screen

local hits = 0
local cycles = 0
local mistakes = 0


function startGame()
	timer.performWithDelay( 600, playMusic )

	background = display.newImageRect("fondo.png", screenW, screenH)
	background.x = screenW/2 + leftX
	background.y = screenH/2 + topY

	myText = display.newText( "Repeticiones", 50, 40, native.systemFont, 48  )
	hits_text = display.newText( "0 (0)", 100, 90, native.systemFont, 48  )
	myText2 = display.newText( "Errores", 500, 40, native.systemFont, 48  )
	mistakes_text = display.newText( "0", 550, 90, native.systemFont, 48  )

	person = display.newImageRect("persona.png", screenW, 1100)
	person.x = leftX + screenW/2
	person.y = bottomY - person.height/2
	person:addEventListener("tap", tapAction)

	heart = display.newImageRect("corazon.png", 140, 140)
	heart.x = 400
	heart.y = screenH/1.6

	local upper_line = display.newLine( leftX, 700, rightX, 700)
	local lower_line = display.newLine( leftX, 950, rightX, 950)

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


	Runtime:addEventListener( "enterFrame", moveHands )


end

function playMusic()
	local backgroundMusic = audio.loadStream( "cancion.mp3" )
	local backgroundMusicChannel = audio.play( backgroundMusic, { channel=1, loops=-1 } )
end

function moveHands()
	for i=1, #hands do
		hands[i].x = hands[i].x - 11.2
		if hands[i].x - hands[i].width/2 < leftX - hands[i].width then
			resetHands(i)
		end
	end
end

function resetHands(hand_index)
	if hand_index == 1 then
		hands[hand_index].x = hands[table.maxn(hands)].x + (2 * hands[hand_index].width)
	else
		hands[hand_index].x = hands[hand_index - 1].x  + (2 * hands[hand_index].width)
	end
end

function tapAction(e)
	miss = false
	for i=1, #hands do
		--print("click: " .. e.x)
		--print("hand: " .. hands[i].x)
		if hands[i].x >= 300 and hands[i].x <= 500 then
			hits = hits + 1
			if hits == 30 then
				cycles = cycles + 1
				hits = 0
			end
			hits_text.text = hits .. " (" .. cycles .. ")"
			system.vibrate()
			miss = true
		end
	end

	if miss == false then
		mistakes = mistakes + 1
		mistakes_text.text = mistakes
	end
end	

media.playVideo( "video.m4v", true, startGame )