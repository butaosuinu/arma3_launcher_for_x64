const fs = require('fs')

let common = {}

common.loadConfigFile = () => {
	return JSON.parse(fs.readFileSync('./config.json', 'utf-8'))
}

common.loadAllPresets = () => {
	let presets = []
	const presetList = fs.readdirSync('./preset')
	for (preset of presetList) {
		presets.push(JSON.parse(fs.readFileSync('./preset/' + preset, 'utf-8')))
	}
	return presets
}

module.exports = common