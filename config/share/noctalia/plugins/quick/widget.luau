-- Quick settings -- bar icon
-- ---------------------------------------------

noctalia.setUpdateInterval(60000)

function update()
	barWidget.setGlyph("toggle-left")
	barWidget.setTooltip("Quick settings")
end
