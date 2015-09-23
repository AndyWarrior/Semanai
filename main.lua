display.setStatusBar( display.HiddenStatusBar )

system.activate("multitouch")

local topY = display.screenOriginY --Numerical value for the top of the screen
local rightX = display.contentWidth - display.screenOriginX --Numerical value for the right of the screen
local bottomY = display.contentHeight - display.screenOriginY --Numerical value for the bottom of the screen
local leftX = display.screenOriginX --Numerical value for the left of the screen
local screenW = rightX - leftX --Numerical value for the width of the screen
local screenH = bottomY - topY --Numerical value for the height of the screen


function startGame()
	person = display.newImageRect("persona.png", 525, 934)
	person.x = leftX + screenW/2
	person.y = bottomY - person.height/2
	person:addEventListener("tap", tapAction)

	local upper_line = display.newLine( leftX, screenH/1.5 + topY, rightX, screenH/1.5 + topY)
	local lower_line = display.newLine( leftX, screenH/2 + topY, rightX, screenH/2 + topY)

	upper_line.strokeWidth = 8
	lower_line.strokeWidth = 8

	hands ={}

	hands[1] = display.newImageRect("mano.png", 80, 80)
	hands[1].x = rightX + hands[1].width
	hands[1].y = screenH/1.75 + hands[1].height/4


	hands[2] = display.newImageRect("mano.png", 80, 80)
	hands[2].x = rightX + (4 * hands[1].width)
	hands[2].y = screenH/1.75 + hands[1].height/4


	hands[3] = display.newImageRect("mano.png", 80, 80)
	hands[3].x = rightX + (7 * hands[1].width)
	hands[3].y = screenH/1.75 + hands[1].height/4

	hands[4] = display.newImageRect("mano.png", 80, 80)
	hands[4].x = rightX + (10 * hands[1].width)
	hands[4].y = screenH/1.75 + hands[1].height/4

	Runtime:addEventListener( "enterFrame", moveHands )


end

function moveHands()
	for i=1, #hands do
		hands[i].x = hands[i].x - 5
		if hands[i].x - hands[i].width/2 < leftX then
			resetHands(i)
		end
	end
end

function resetHands(hand_index)
	if hand_index == 1 then
		hands[hand_index].x = hands[table.maxn(hands)].x + (3 * hands[hand_index].width)
	else
		hands[hand_index].x = hands[hand_index - 1].x  + (3 * hands[hand_index].width)
	end
end

function tapAction(e)
	for i=1, #hands do
		print("click: " .. e.x)
		print("hand: " .. hands[i].x)
		if hands[i].x >= 360 and hands[i].x <= 440 then
			print("hit!!!")
		end
	end
end	

startGame()