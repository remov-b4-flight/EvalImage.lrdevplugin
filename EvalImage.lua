--[[
EvalImage.lrplugin
@file EvalFocus.lua
@author @remov_b4_flight
]]

local PluginTitle = 'EvalImage'
local LrApplication = import 'LrApplication'
local LrLogger = import 'LrLogger'
local LrTasks = import 'LrTasks'
local LrProgress = import 'LrProgressScope'
local Logger = LrLogger(PluginTitle)

Logger:enable('logfile')

local AutoReject = 30
local MINRESULT = 5

local CurrentCatalog = LrApplication.activeCatalog()
local shell = 'sh '
local python = 'python3 '
local script = '/evalfocus.py '

function getRank(accuracy)
	local r = nil
	if (accuracy >= 200) then r = 'A++'
	elseif (accuracy >= 150) then r = 'A+'
	elseif (accuracy >= 100) then r = 'A'
	elseif (accuracy >= 50) then r = 'B'
	elseif (accuracy >= MINRESULT) then r = 'C'
	end
	return r
end

--Main part of this plugin.
LrTasks.startAsyncTask( function ()
	local ProgressBar = LrProgress(
		{title = PluginTitle .. ' Running..'}
	)
	local TargetPhoto = CurrentCatalog:getTargetPhoto()
	local SelectedPhotos = CurrentCatalog:getTargetPhotos()
	local countPhotos = #SelectedPhotos
	--loops photos in selected
	CurrentCatalog:withWriteAccessDo('Evaluate Image',function()
		local script_path = _PLUGIN.path .. script
		Logger:debug('-loop-')
		for i,PhotoIt in ipairs(SelectedPhotos) do
			local FilePath = PhotoIt:getRawMetadata('path')
			local CommandLine = shell .. python .. script_path .. FilePath 
			Logger:debug(FilePath)
			local Accuracy = LrTasks.execute(CommandLine)
			Logger:debug('Accuracy = ' .. Accuracy)
			if (MINRESULT <= Accuracy) then

				PhotoIt:setPropertyForPlugin(_PLUGIN,'accuracy',Accuracy)
				local Rank = getRank(Accuracy)
				if Rank ~= nil then
					Logger:debug('Rank = ' .. Rank)
					PhotoIt:setPropertyForPlugin(_PLUGIN,'rank',Rank)
				end
				if (Accuracy < AutoReject) then
					PhotoIt:setRawMetadata('pickStatus', -1)
				end
			end
			ProgressBar:setPortionComplete(i,countPhotos)
		end --end of for photos loop
		ProgressBar:done()
	end ) --end of withWriteAccessDo
Logger:debug('-end-')
end ) --end of startAsyncTask function()
return
