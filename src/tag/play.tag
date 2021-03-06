<play>
	<main-menu></main-menu>
	<div class="uk-margin-top">
	<form class="uk-form uk-form-horizontal">
		<div class="uk-form-row">
			<label class="uk-form-label">Select preset</label>
			<div class="uk-form-controls">
				<select ref="preset">
					<option value="">no addon</option>
					<option each={ preset in presets } value="{ preset.value }">{ preset.name }</option>
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
		const path = require('path')
		const exec = require('child_process').exec
		const util = require('../js/utilService.js')

		const config = util.loadConfigFile()

		this.a3dir = ''
		this.modsDir = ''
		this.launchString = ''
		this.addonsString = ''

		this.on('mount', ()=> {
			self.presets = util.loadAllPresets()
			self.baseSetting()
			self.setLaunchParam()
			self.update()
			self.refs.preset.value = util.loadLastUsePreset()
		})

		this.baseSetting = ()=> {
			let exeName = ''

			if (32 === config.client) {
				exeName = 'arma3.exe'
			} else {
				exeName = 'arma3_x64.exe'
			}

			self.a3dir = config.a3dir + '/'
			self.modsDir = config.mods_dir + '/'
			if (os.type().toString().match('Windows') !== null) {
				self.a3dir = config.a3dir + '\\'
				self.modsDir = config.mods_dir + '\\'
			}
			self.launchString = '"' + self.a3dir + exeName + '" ' + config.option
		}

		this.setLaunchParam = ()=> {
			if (config.no_intro) {self.launchString = self.launchString + ' -skipIntro'}
			if (config.no_splash) {self.launchString = self.launchString + ' -noSplash'}
			if (config.window) {self.launchString = self.launchString + ' -window'}
			self.launchString = self.launchString + ' -name=' + config.name
		}

		this.loadAddonsString = ()=> {
			this.addonsString = ''
			console.log(self.refs.preset.value)
			const fileName = self.refs.preset.value.replace(/ /g, '_') + '.json'
			let addonsArr = util.loadAddonsInPreset(fileName)
			addonsArr = addonsArr.map((addon)=>{
				return JSON.parse(addon.value)
			})
			for (let addon of addonsArr) {
				let addonName = ''
				if ('steam' === addon.type) {
					addonName = path.join(self.a3dir, '!Workshop', addon.name)
				} else {
					addonName = self.modsDir + addon.name
				}
				this.addonsString = this.addonsString + addonName + ';'
			}
			this.addonsString = ' "-mod=' + this.addonsString + '"'
		}

		this.launchGame = function() {
			self.loadAddonsString()
			exec(this.launchString + this.addonsString, (err, stdout, stderr) => {
				if (err) {console.error(err)}
				console.log(stdout)
				util.savingLastUsePreset(self.refs.preset.value.replace(/ /g, '_'))
			})
		}
	</script>
</play>