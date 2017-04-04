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

common.loadAddonsInPreset = (name) => {
	const preset = JSON.parse(fs.readFileSync('./preset/' + name, 'utf-8'))
	return preset.addons
}

module.exports = common