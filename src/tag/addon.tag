<addon>
	<form class="uk-form uk-form-horizontal" name="presetSetting">
		<div class="uk-form-row">
			<label class="uk-form-label">Select preset</label>
			<div class="uk-form-controls">
				<select ref="preset" onchange="{ newPreset }">
					<option value="0"> - new preset - </option>
					<option each={ preset in presets }>{ preset.name }</option>
				</select>
			</div>
		</div>
		<div class="uk-form-row" if={ isNewPreset }>
			<label class="uk-form-label">preset name</label>
			<div class="uk-form-controls">
				<input class="uk-width-1-2" type="text" ref="newPresetName">
			</div>
			<p class="uk-text-danger" if="{ isInputName }">You must input preset name!</p>
		</div>
		<div class="uk-form-row uk-width-3-4 uk-grid">
			<div class="uk-width-1-2">
				<div>
					<select id="allAddon" class="addon-area" name="allAddon" ref="allAddons" multiple>
						<option each={ addon in addons }>{ addon }<option>
					</select>
				</div>
				<button class="uk-button" type="button" onclick="{ addAddon }">add</button>
			</div>
			<div class="uk-width-1-2">
				<div>
					<select class="addon-area" ref="addonInPreset" multiple>
						<option each={ addon in addonsInPreset }>{ addon }</option>
					</select>
				</div>
				<button class="uk-button" type="button" onclick="{ removeAddon }">remove</button>
				<!-- <button class="uk-button" type="button"><i class="uk-icon-arrow-up"></i></button> -->
				<!-- <button class="uk-button" type="button"><i class="uk-icon-arrow-down"></i></button> -->
			</div>
		</div>
		<button class="uk-margin-top uk-button uk-button-primary uk-button-large" type="button" onclick="{ savePreset }">Save preset</button>
		<button class="uk-margin-top uk-button uk-button-large" type="button">Cancel</button>
		<button class="uk-margin-top uk-button uk-button-danger uk-button-large" type="button" if={ !isNewPreset } onclick="{ deletePreset }">Delete preset</button>
		<p class="uk-text-success" if="{ isSave }">save successed</p>
	</form>

	<style type="scss">
		.addon-area{
			width: 100%;
			height: 240px !important;
		}
	</style>

	<script type="es6">
		const fs = require('fs')
		const common = require('../js/utilService.js')
		const self = this

		this.on('mount', (()=> {
			if (0 == self.refs.preset.value) {
				self.isNewPreset = true
			} else {
				self.isNewPreset = false
			}
			self.isInputName = false
			self.addons = []
			self.presets = []
			self.addonsInPreset = []
			self.loadPreset()
			self.loadAddonsInA3Dir()
			self.update()
		}))

		this.newPreset = ()=> {
			if ("0" === self.refs.preset.value) {
				self.isNewPreset = true
				self.addonsInPreset = []
			} else {
				self.isNewPreset = false
				self.addonsInPreset = self.loadAddonsInPreset(self.refs.preset.value + '.json')
			}
			self.isInputName = false
			self.update()
		}

		this.loadAddonsInA3Dir = ()=> {
			const config = common.loadConfigFile()
			const addonList = fs.readdirSync(config.a3dir)
			for (addon of addonList) {
				if ("@" === addon.substring(0, 1)) {
					self.addons.push(addon)
				}
			}
			self.update()
		}

		this.loadPreset = ()=> {
			self.presets = []
			const presetList = fs.readdirSync('preset')
			for (preset of presetList) {
				self.presets.push(JSON.parse(fs.readFileSync('./preset/' + preset, 'utf-8')))
			}
			self.update()
		}

		this.loadAddonsInPreset = (name)=> {
			preset = JSON.parse(fs.readFileSync('./preset/' + name, 'utf-8'))
			return preset.addons
		}

		this.addAddon = ()=> {
			let distList = new Set()
			let addList = []
			for (addon of self.refs.allAddons) {
				if (addon.selected) {addList.push(addon.value)}
			}
			[...(new Set(self.addonsInPreset)),...(new Set(addList))].forEach(x=>distList.add(x))
			self.addonsInPreset = [...distList]
			self.update()
		}

		this.removeAddon = ()=> {
			const addonInPreset = self.refs.addonInPreset
			let selectedArr = []
			for (selected of addonInPreset) {
				if (selected.selected) {selectedArr.push(selected.value)}
					selected.selected = false
			}
			for (selected of selectedArr) {
				self.addonsInPreset = self.addonsInPreset.filter((v)=> {
					return v !== selected
				})
			}
			self.update()
		}

		this.upAddon = ()=> {
			// body...
		}

		this.downAddon = ()=> {
			// body...
		}

		this.savePreset = ()=> {
			let presetName = ''
			if ("0" !== self.refs.preset.value) {
				presetName = self.refs.preset.value
			} else if ('' === self.refs.newPresetName.value) {
				self.isInputName = true
				return
			} else {
				presetName = self.refs.newPresetName.value
			}

			let addons
			if (self.addonsInPreset) {
				addons = self.addonsInPreset
			} else {
				addons = []
			}

			const data = {
				name: presetName,
				addons: addons
			}
			const fileName = presetName.replace(' ', '_') + '.json'
			fs.writeFile('./preset/' + fileName, JSON.stringify(data, null, ' '), function(err) {
				if (err) {
					console.log(err)
					return
				}
				self.isSave = true
				self.update()
				window.setTimeout(()=>{
					self.isSave = false
					self.loadPreset()
					self.newPreset()
					self.refs.newPresetName.value = ''
					self.update()
				}, 1000)
			})
		}

		this.deletePreset = ()=> {
			const targetPreset = self.refs.preset.value
			const fileName = targetPreset.replace(' ', '_') + '.json'
			fs.unlink('./preset/' + fileName, function(err) {
				if (err) {
					console.log(err)
					return
				}
				self.loadPreset()
				self.newPreset()
				self.update()
			})
		}

	</script>
</addon>