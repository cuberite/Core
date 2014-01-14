WorkWorldName = ""
WorkWorld = {}

local function AddWorldButton( inName )
	return "<form method='POST'><input type='submit' name='WorldName' value='"..inName.."'></form>"
end

function HandleRequest_Weather( Request )
	if( Request.PostParams["WorldName"] ~= nil ) then		-- World is selected!
		WorkWorldName = Request.PostParams["WorldName"]
		WorkWorld = cRoot:Get():GetWorld( WorkWorldName )
	end
	
	if (Request.PostParams["FormDay"] ~= nil) then
		WorkWorld:SetTimeOfDay( 0 )
		LOG( "Daylight on in "..WorkWorldName )
	end
	if (Request.PostParams["FormNight"] ~= nil) then
		WorkWorld:SetTimeOfDay( 13000 )
		LOG( "Night time on in "..WorkWorldName )
	end
	
	if (Request.PostParams["FormSun"] ~= nil) then
		WorkWorld:SetWeather(0)
		LOG( "Sunny times in "..WorkWorldName )
	end
	if (Request.PostParams["FormRain"] ~= nil) then
		WorkWorld:SetWeather(1)
		LOG( "Water drops from the sky in "..WorkWorldName )
	end
	
	local content = GenerateContent()
	return content
end

function GenerateContent()
	local content = ""
	-- SELECTING WORK_WORLD
	if( WorkWorldName == "" ) then
		content = content.."<h4>Select World for operations:</h4>"
	else
		content = content.."<h4>World for operations: "..WorkWorldName.."</h4>"
	end
	
	local worldCount = 0
	local AddWorldToTable = function( inWorld )
		worldCount = worldCount + 1
		content = content.."<td>"..AddWorldButton( inWorld:GetName() ).."</td>"
	end
	
	content = content.."<table><tr>"
	cRoot:Get():ForEachWorld( AddWorldToTable )
	if( worldCount == 0 ) then
		content = content.."<td>No worlds! O_O</td>"
	end
	content = content.."</tr></table>"
	content = content.."<br>"
	
	if( WorkWorldName ~= "" ) then
		-- SELECTING TIME
		content = content.."<h4>Time:   </h4>"
		content = content.."<form method='POST'>"
		content = content.."<input type='submit' name='FormDay' value='Day'>"
		content = content.."<input type='submit' name='FormNight' value='Night'>"
		content = content.."</form>"
		
		-- SELECTING WEATHER
		content = content.."<h4>Weather:   </h4>"
		content = content.."<form method='POST'>"
		content = content.."<input type='submit' name='FormSun' value='Sun'>"
		content = content.."<input type='submit' name='FormRain' value='Rain'>"
		content = content.."</form>"
	end
	
	return content
end
