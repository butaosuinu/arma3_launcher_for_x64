const fs = require('fs')

let common = {}

common.loadConfigFile = () => {
	return JSON.parse(fs.readFileSync('./config.json', 'utf-8'))
}


module.exports = common