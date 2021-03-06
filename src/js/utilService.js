const app = require('electron').remote.app
const fs = require('fs')
const path = require('path')

let util = {}

util.loadConfigFile = () => {
	if (!util.isExistFileOrDir(path.join(app.getAppPath(), 'config.json'))) {
		initConfig()
	}
	return JSON.parse(fs.readFileSync(path.join(app.getAppPath(), 'config.json') || 'null', 'utf-8'))
}

util.loadAllPresets = () => {
	let presets = []
	if (!util.isExistFileOrDir(path.join(app.getAppPath(), 'preset'))) {
		fs.mkdirSync(path.join(app.getAppPath(), 'preset'))
	}
	const presetList = fs.readdirSync(path.join(app.getAppPath(), 'preset'))
	for (let preset of presetList) {
		presets.push(JSON.parse(fs.readFileSync(path.join(app.getAppPath(), 'preset/' + preset), 'utf-8')))
	}
	presets = presets.map((v)=>{
		let obj = {}
		obj['name'] = v.name
		obj['value'] = v.name.replace(/ /g, '_')
		return obj
	})
	return presets
}

util.loadAddonsInPreset = (name) => {
	const presetJSON = JSON.parse(fs.readFileSync(path.join(app.getAppPath(), 'preset/' + name), 'utf-8'))
	const localArr = presetJSON.addons.map((addon)=>{
		return {text: addon, value: JSON.stringify({name: addon, type: 'local'})}
	})
	const swArr = presetJSON.steam.map((addon)=>{
		return {
			text: addon + ' (Steam workshop)',
			value: JSON.stringify({name: addon, type: 'steam'})
		}
	})
	const preset = localArr.concat(swArr)

	return preset
}

util.isExistFileOrDir = (name) => {
	try {
		fs.statSync(name)
		return true
	} catch(e) {
		if (e.code === 'ENOENT') {return false}
	}
}

util.savingLastUsePreset = (preset) => {
	localStorage.setItem('lastUsePreset', preset)
}

util.loadLastUsePreset = () => {
	return localStorage.lastUsePreset
}

const initConfig = () => {
	const data = {
		client: 64,
		a3dir: null,
		mods_dir: null,
		option: null
	}
	fs.writeFile(path.join(app.getAppPath(), 'config.json'), JSON.stringify(data, null, ' '), function(err) {
		if (err) {
			console.log(err)
			return
		}
	})
}

module.exports = util
