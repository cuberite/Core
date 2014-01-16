local function AddWorldButtons( inName )
	result = "<form method='POST'><input type='hidden' name='WorldName' value='"..inName.."'>"
	result = result.."<input type='submit' name='SetTime' value='Day'>"
	result = result.."<input type='submit' name='SetTime' value='Night'>"
	result = result.."<input type='submit' name='SetWeather' value='Sun'>"
	result = result.."<input type='submit' name='SetWeather' value='Rain'></form>"
	return result
end

function HandleRequest_Weather( Request )
	if( Request.PostParams["WorldName"] ~= nil ) then		-- World is selected!
		workWorldName = Request.PostParams["WorldName"]
		workWorld = cRoot:Get():GetWorld( workWorldName )
		if( Request.PostParams["SetTime"] ~= nil ) then
			if( Request.PostParams["SetTime"] == "Day" ) then
				workWorld:SetTimeOfDay( 0 )
				LOG( "Daylight on in "..workWorldName )
			elseif( Request.PostParams["SetTime"] == "Night" ) then
				workWorld:SetTimeOfDay( 13000 )
				LOG( "Night time on in "..workWorldName )
			end
		end
		
		if( Request.PostParams["SetWeather"] ~= nil ) then
			if( Request.PostParams["SetWeather"] == "Sun" ) then
				workWorld:SetWeather( 0 )
				LOG( "Sunny times in "..workWorldName )
			elseif( Request.PostParams["SetWeather"] == "Rain" ) then
				workWorld:SetWeather( 1 )
				LOG( "Water drops from the sky in "..workWorldName )
			end
		end
	end
	
	local content = GenerateContent()
	return content
end

function GenerateContent()
	local content = "<h4>Operations:</h4><br>"
	local worldCount = 0
	local AddWorldToTable = function( inWorld )
		worldCount = worldCount + 1
		content = content.."<tr><td style='width: 10px;'>"..worldCount..".</td><td>"..inWorld:GetName().."</td>"
		content = content.."<td>"..AddWorldButtons( inWorld:GetName() ).."</td></tr>"
	end
	
	content = content.."<table>"
	cRoot:Get():ForEachWorld( AddWorldToTable )
	if( worldCount == 0 ) then
		content = content.."<tr><td>No worlds! O_O</td></tr>"
	end
	content = content.."</table>"
	
	return content
end
