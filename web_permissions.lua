
-- web_permissions.lua

-- Implements the Permissions tab in the webadmin





--- Maximum number of permissions displayed within a group's row.
-- If there are more permissions than this, a triple-dot is displayed at the end of the list
local MAX_PERMISSIONS = 10

local ins = table.insert
local con = table.concat





--- Returns the HTML for a single group's row in the listing table
local function GetGroupRow(a_GroupName)
	-- Check params:
	assert(type(a_GroupName) == "string")
	
	-- First column: group name:
	local Row = {"<tr><td>"}
	ins(Row, cWebAdmin:GetHTMLEscapedString(a_GroupName))
	ins(Row, "</td><td>")
	
	-- Second column: permissions:
	local Permissions = cRankManager:GetGroupPermissions(a_GroupName)
	table.sort(Permissions)
	local NumPermissions = #Permissions
	if (NumPermissions <= MAX_PERMISSIONS) then
		ins(Row, con(Permissions, "<br/>"))
	else
		ins(Row, con(Permissions, "<br/>", 1, MAX_PERMISSIONS))
		ins(Row, "<br/>...")
	end
	ins(Row, "</td><td>")
	
	-- Third column: operations:
	ins(Row, "<form>")
	ins(Row, GetFormButton("editpermissions", "Edit permissions", {GroupName = a_GroupName}))
	ins(Row, "</form><form>")
	ins(Row, GetFormButton("confirmdelgroup", "Delete group", {GroupName = a_GroupName}))
	ins(Row, "</form></td></tr>")

	return con(Row)
end





--- Displays the main Permissions page, listing the permission groups and their permissions
local function ShowMainPermissionsPage(a_Request)
	local Page = {"<h4>Create a new group</h4>"}
	
	-- Add the header for adding a new group:
	ins(Page, "<form method='POST'><table><tr><th>Group name:</th><td><input type='text' name='GroupName'/></td></tr><tr><th/><td>")
	ins(Page, GetFormButton("addgroup", "Create a new group", {}))
	ins(Page, "</td></tr></table></form>")
	
	-- Display a table showing all groups currently known:
	ins(Page, "<h4>Groups</h4><table><tr><th>Group name</th><th>Permissions</th><th>Actions</th></tr>")
	local AllGroups = cRankManager:GetAllGroups()
	table.sort(AllGroups)
	for _, group in ipairs(AllGroups) do
		ins(Page, GetGroupRow(group))
	end
	ins(Page, "</table>")
	
	return con(Page)
end





--- Handles the AddGroup form in the main page
-- Adds the group and redirects the user back to the group list
local function ShowAddGroupPage(a_Request)
	-- Check params:
	local GroupName = a_Request.PostParams["GroupName"]
	if (GroupName == nil) then
		return HTMLError("Bad request, missing parameters.")
	end
	
	-- Add the group:
	cRankManager:AddGroup(GroupName)
	
	-- Redirect the user:
	return "<p>Group created. <a href='/" .. a_Request.Path .. "'>Return to group list</a>.</p>"
end





--- Handles the AddPermission form in the Edit permissions page
-- Adds the permission to the group and redirects the user back to the permission list
local function ShowAddPermissionPage(a_Request)
	-- Check params:
	local GroupName = a_Request.PostParams["GroupName"]
	local Permission = a_Request.PostParams["Permission"]
	if ((GroupName == nil) or (Permission == nil)) then
		return HTMLError("Bad request, missing parameters.")
	end
	
	-- Add the permission:
	cRankManager:AddPermissionToGroup(Permission, GroupName)
	
	-- Redirect the user:
	return
		"<p>Permission added. <a href='/" ..
		a_Request.Path ..
		"?subpage=editpermissions&GroupName=" ..
		cWebAdmin:GetHTMLEscapedString(GroupName) ..
		"'>Return to group list</a>.</p>"
end





--- Shows a confirmation page for deleting a group
local function ShowConfirmDelGroupPage(a_Request)
	-- Check params:
	local GroupName = a_Request.PostParams["GroupName"]
	if (GroupName == nil) then
		return HTMLError("Bad request, missing parameters.")
	end
	
	-- Show the confirmation request:
	local Page =
	{
		"<h4>Delete group</h4><p>Are you sure you want to delete group ",
		GroupName,
		"? It will be removed from all the ranks that are using it.</p>",
		"<form method='POST'>",
		GetFormButton("delgroup", "Delete the group", {GroupName = GroupName}),
		"</form><form method='GET'>",
		GetFormButton("", "Do NOT delete", {}),
		"</form>"
	}
	return con(Page)
end





--- Handles the DelGroup button in the ConfirmDelGroup page
-- Removes the group and redirects the user back to the group list
local function ShowDelGroupPage(a_Request)
	-- Check params:
	local GroupName = a_Request.PostParams["GroupName"]
	if (GroupName == nil) then
		return HTMLError("Bad request, missing parameters.")
	end
	
	-- Remove the group:
	cRankManager:RemoveGroup(GroupName)
	
	-- Redirect the user:
	return
		"<p>Group removed. <a href='/" ..
		a_Request.Path ..
		"'>Return to group list</a>.</p>"
end





-- Handles the DelPermission form in the Edit permissions page
-- Removes the permission from the group and redirects the user back to the permission list
local function ShowDelPermissionPage(a_Request)
	-- Check params:
	local GroupName = a_Request.PostParams["GroupName"]
	local Permission = a_Request.PostParams["Permission"]
	if ((GroupName == nil) or (Permission == nil)) then
		return HTMLError("Bad request, missing parameters.")
	end
	
	-- Add the permission:
	cRankManager:RemovePermissionFromGroup(Permission, GroupName)
	
	-- Redirect the user:
	return
		"<p>Permission removed. <a href='/" ..
		a_Request.Path ..
		"?subpage=editpermissions&GroupName=" ..
		cWebAdmin:GetHTMLEscapedString(GroupName) ..
		"'>Return to group list</a>.</p>"
end





--- Displays the Edit Permissions page for a single group
local function ShowEditPermissionsPage(a_Request)
	-- Check params:
	local GroupName = a_Request.PostParams["GroupName"]
	if (GroupName == nil) then
		return HTMLError("Bad request, missing parameters.")
	end
	
	-- Add the header for adding permissions:
	local Page = {[[
		<p><a href='/]] .. a_Request.Path .. [['>Return to the group list</a>.</p>
		<h4>Add a permission</h4>
		<form method='POST'><table><tr><th>Permission</th><td><input type='text' name='Permission'/></td></tr>
		<tr><th/><td>
	]]}
	ins(Page, GetFormButton("addpermission", "Add permission", {GroupName = GroupName}))
	ins(Page, "</td></tr></table></form>")
	
	-- Add the permission list:
	local Permissions = cRankManager:GetGroupPermissions(GroupName)
	table.sort(Permissions)
	ins(Page, "<h4>Group permissions</h4><table>")
	for _, permission in ipairs(Permissions) do
		ins(Page, "<tr><td>")
		ins(Page, cWebAdmin:GetHTMLEscapedString(permission))
		ins(Page, "</td><td><form method='POST'>")
		ins(Page, GetFormButton("delpermission", "Remove permission", {GroupName = GroupName, Permission = permission}))
		ins(Page, "</form></td></tr>")
	end
	ins(Page, "</table>")
	
	return con(Page)
end





--- Handlers for the individual subpages in this tab
-- Each item maps a subpage name to a handler function that receives a HTTPRequest object and returns the HTML to return
local g_SubpageHandlers =
{
	[""]                = ShowMainPermissionsPage,
	["addgroup"]        = ShowAddGroupPage,
	["addpermission"]   = ShowAddPermissionPage,
	["confirmdelgroup"] = ShowConfirmDelGroupPage,
	["delgroup"]        = ShowDelGroupPage,
	["delpermission"]   = ShowDelPermissionPage,
	["editpermissions"] = ShowEditPermissionsPage,
}





--- Handles the web request coming from MCS
-- Returns the entire tab's HTML contents, based on the player's request
function HandleRequest_Permissions(a_Request)
	local Subpage = (a_Request.PostParams["subpage"] or "")
	local Handler = g_SubpageHandlers[Subpage]
	if (Handler == nil) then
		return HTMLError("An internal error has occurred, no handler for subpage " .. Subpage .. ".")
	end
	
	local PageContent = Handler(a_Request)
	
	--[[
	-- DEBUG: Save content to a file for debugging purposes:
	local f = io.open("permissions.html", "wb")
	if (f ~= nil) then
		f:write(PageContent)
		f:close()
	end
	--]]
	
	return PageContent
end





