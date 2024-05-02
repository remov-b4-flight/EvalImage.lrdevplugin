--[[
EvalFocus.lrplugin
@file MetadataDefinition.lua
@author @remov_b4_flight
]]

return {
	metadataFieldsForPhotos = {
		{id = 'result', title = 'Result', datatype = 'enum', browsable = true, searchable = true, readOnly = true 
			values = {
				 {value = nil, title ='unknown'},
				 {value = 'yes', title ='looks good'},
				 {value = 'no', title ='rejectable'},
			},
		},
	},
	schemaVersion = 1,
}
