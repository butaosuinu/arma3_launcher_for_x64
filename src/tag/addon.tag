<addon>
	<main-menu></main-menu>
	<div class="uk-margin-top">
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
					<label>Addons in Arma3 folder</label>
					<div id="allAddon" class="addon-area"></div>
				</div>
				<button class="uk-button" type="button" onclick="{ addAddon }">add</button>
			</div>
			<div class="uk-width-1-2">
				<div>
					<label>Addons in preset</label>
					<div id="presetAddon" class="addon-area"></div>
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
	</div>

	<style type="scss">
		.addon-area{
			width: 100%;
			height: 240px !important;
		}

		.multiselect-outer-div {
			width: 100% !important;
			height: 240px !important;
			border: 1px solid #CCC;
		}

		.multiselect-outer-div ul {
			list-style: none;
			padding: 0px;
			margin: 0px;
		}

		.multiselect-outer-div ul li {
			cursor: default;
			padding: 4px;
			border-bottom: 1px solid #EEE;
			display: list-item;
			color: #111;
		}

		.multiselect-outer-div ul li:hover {
			background-color: #CCC;
			text-decoration: none;
			color: #FFFFFF;
		}

		.multiselect-li-selected {
			background-color: #35b3ee !important;
			color: #FFFFFF !important;
			text-decoration: none;
		}
	</style>

	<script type="es6">
		const fs = require('fs')
		const path = require('path')
		const {app} = require('electron').remote
		const common = require('../js/utilService.js')
		const self = this

		let addonsInDir
		let addonsInPresetSelectbox
		let allAddonList

		require('simple-multiselect')

		this.on('mount', (()=> {
			if ("0" === self.refs.preset.value) {
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
			self.updateSelectBox()
			self.update()
		}))

		this.updateSelectBox = () => {
			if (document.querySelector('#allAddon div')) {
				document.querySelector('#allAddon div').parentNode.removeChild(document.querySelector('#allAddon div'))
			}
			if (document.querySelector('#presetAddon div')) {
				document.querySelector('#presetAddon div').parentNode.removeChild(document.querySelector('#presetAddon div'))
			}
			const addonData = self.addons.map((addon)=>{
				let obj = {}
				obj['value'] = addon
				obj['text'] = addon
				return obj
			})
			addonsInDir = window.multiselect.render({
				elementId: 'allAddon',
				data: addonData
			})
			const inPresetData = self.addonsInPreset.map((addon)=>{
				let obj2 = {}
				obj2['value'] = addon
				obj2['text'] = addon
				return obj2
			})
			addonsInPresetSelectbox = window.multiselect.render({
				elementId: 'presetAddon',
				data: inPresetData
			})
		}

		this.newPreset = ()=> {
			if ("0" === self.refs.preset.value) {
				self.isNewPreset = true
				self.addonsInPreset = []
			} else {
				const fileName = self.refs.preset.value.replace(' ', '_') + '.json'
				self.isNewPreset = false
				self.addonsInPreset = common.loadAddonsInPreset(fileName)
			}
			self.diffAddons()
			self.updateSelectBox()
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
			allAddonList = self.addons
			self.update()
		}

		this.loadPreset = ()=> {
			self.presets = common.loadAllPresets()
			self.update()
		}

		this.addAddon = ()=> {
			let distList = new Set();
			[...(new Set(self.addonsInPreset)),...(new Set(addonsInDir.getSelectedValues()))].forEach(x=>distList.add(x))
			self.addonsInPreset = [...distList]
			self.diffAddons()
			self.updateSelectBox()
			self.update()
		}

		this.removeAddon = ()=> {
			const selectedArr = addonsInPresetSelectbox.getSelectedValues()
			for (selected of selectedArr) {
				self.addonsInPreset = self.addonsInPreset.filter((v)=> {
					return v !== selected
				})
			}
			self.diffAddons()
			self.updateSelectBox()
			self.update()
		}

		this.upAddon = ()=> {
			// body...
		}

		this.downAddon = ()=> {
			// body...
		}

		this.diffAddons = ()=> {
			self.addons = allAddonList
			for (va of self.addonsInPreset) {
				self.addons = self.addons.filter((v)=> {
					return v !== va
				})
			}
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
			fs.writeFile(path.join(app.getAppPath(), 'preset/' + fileName), JSON.stringify(data, null, ' '), function(err) {
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
			fs.unlink(path.join(app.getAppPath(), 'preset/' + fileName), function(err) {
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