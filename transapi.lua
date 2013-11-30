--
-- The MIT License (MIT)
--
-- Copyright (c) 2013 Alexander Harkness
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of
-- this software and associated documentation files (the "Software"), to deal in
-- the Software without restriction, including without limitation the rights to
-- use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
-- the Software, and to permit persons to whom the Software is furnished to do so,
-- subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
-- FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
-- COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
-- IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
-- CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--

-- Configuration

local defaultLang = "en" -- Language provided with the plugin. Users must not change or bad things may happen.

-- Start the code.

function GetTranslation( Slug, Player )

	-- Get a reference to the helper plugin.
	local helper = cPluginManager():Get():GetPlugin( "TransAPI" )

	-- Ask the helper plugin what language the player likes.
	local preferredLanguage = helper:Call( "GetLanguage", Player )

	if g_Languages[preferredLanguage][Slug] ~= nil then
		return g_Languages[preferredLanguage][Slug]
	else
		return g_Languages[defaultLang][Slug]
	end

end

function GetConsoleTranslation( Slug )

	-- Get a reference to the helper plugin.
	local helper = cPluginManager:Get():GetPlugin( "TransAPI" )

	local preferredLanguage = helper:Call( "GetConsoleLanguage" )

	if g_Languages[preferredLanguage][Slug] ~= nil then
		return g_Languages[preferredLanguage][Slug]
	else
		return g_Languages[defaultLang][Slug]
	end

end
