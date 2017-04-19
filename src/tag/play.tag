<play>
	<main-menu></main-menu>
	<div class="uk-margin-top">
	<form class="uk-form uk-form-horizontal">
		<div class="uk-form-row">
			<label class="uk-form-label">Select preset</label>
			<div class="uk-form-controls">
				<select ref="preset" onchange="{ loadAddonsString }">
					<option value="">no addon</option>
					<option each={ preset in presets }>{ preset.name }</option>
				</select>
			</div>
		</div>
		<button class="uk-button uk-button-primary launch-button" type="button" onclick="{ launchGame }">Arma3 launch</button>
	</form>
	</div>

	<style type="scss">
		.launch-button{
			padding: 30px;
			margin-top: 50px;
			font-size: 32px;
		}
	</style>

	<script type="es6">
		const self = this
		const fs = require('fs')
		const os = require('os')
		const exec = require('child_process').exec
		const util = require('../js/utilService.js')

		this.a3dir = ''
		this.launchString = ''
		this.addonsString = ''

		this.on('mount', ()=> {
			self.presets = util.loadAllPresets()
			self.baseSetting()
			self.update()
		})

		this.baseSetting = ()=> {
			const config = util.loadConfigFile()
			let exeName = ''

			if (32 === config.client) {
				exeName = 'arma3.exe'
			} else {
				exeName = 'arma3_x64.exe'
			}

			self.a3dir = config.a3dir + '/'
			if (os.type().toString().match('Windows') !== null) {self.a3dir = config.a3dir + '\\'}
			self.launchString = '"' + self.a3dir + exeName + '" ' + config.option
		}

		this.loadAddonsString = ()=> {
			this.addonsString = ''
			const fileName = self.refs.preset.value.replace(' ', '_') + '.json'
			const addonsArr = util.loadAddonsInPreset(fileName)
			for (let addon of addonsArr) {
				addon = self.a3dir + addon + ';'
				this.addonsString = this.addonsString + addon
			}
			this.addonsString = ' "-mod=' + this.addonsString + '"'
		}

		this.launchGame = function() {
			exec(this.launchString + this.addonsString, (err, stdout, stderr) => {
				if (err) {console.log(err)}
				console.log(stdout)
			})
		}
	</script>
</play>