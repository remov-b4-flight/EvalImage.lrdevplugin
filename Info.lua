--[[
EvalImage.lrplugin
@file Info.lua
@author @remov_b4_flight
]]

return {

	LrSdkVersion = 3.0,

	LrToolkitIdentifier = 'nu.mine.ruffles.evalimage',
	LrPluginName = 'EvalImage',
	LrPluginInfoUrl='https://twitter.com/remov_b4_flight',
	LrMetadataProvider = 'MetadataDefinition.lua',
	LrLibraryMenuItems = { 
		{title = 'Evaluate',
		file = 'EvalImage.lua',
		enabledWhen = 'photosAvailable',},
		{title = 'Clear Evaluate',
		file = 'EvalClear.lua',
		enabledWhen = 'photosAvailable',},
	},
	VERSION = { major=0, minor=0, revision=0, build=0, },

}
