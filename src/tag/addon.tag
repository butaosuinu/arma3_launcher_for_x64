<addon>
	<main-menu></main-menu>
	<div class="uk-margin-top">
	<form class="uk-form uk-form-horizontal" name="presetSetting">
		<div class="uk-form-row">
			<label class="uk-form-label">Select preset</label>
			<div class="uk-form-controls">
				<select ref="preset" onchange="{ newPreset }">
					<option value=""> - new preset - </option>
					<option each={ preset in presets } value="{ preset.value }">{ preset.name }</option>
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
		<div class="uk-form-row uk-grid">
			<div class="uk-width-1-2">
				<div>
					<label>Addons in Arma3 folder</label>
					<div id="allAddon" class="addon-area"></div>
				</div>
				<button class="uk-button" type="button" onclick="{ addAddon }">add</button>
				<button class="uk-button" type="button" onclick="{ reloadAddon }"><i class="uk-icon-refresh"></i></button>
			</div>
			<div class="uk-width-1-2">
				<div>
					<label>Addons in preset</label>
					<div id="presetAddon" class="addon-area"></div>
				</div>
				<button class="uk-button" type="button" onclick="{ removeAddon }">remove</button>
				<button class="uk-button" type="button" onclick="{ upAddon }"><i class="uk-icon-arrow-up"></i></button>
				<button class="uk-button" type="button" onclick="{ downAddon }"><i class="uk-icon-arrow-down"></i></button>
			</div>
		</div>
		<button class="uk-margin-top uk-button uk-button-primary uk-button-large" type="button" onclick="{ savePreset }">Save preset</button>
		<button class="uk-margin-top uk-button uk-button-large" type="button">Cancel</button>
		<button class="uk-margin-top uk-button uk-button-danger uk-button-large" type="button" if={ !isNewPreset } onclick="{ showDelModal }">Delete preset</button>
	</form>
	</div>

	<div id="del-modal" class="uk-modal">
		<div class="uk-modal-dialog">
			<p>Are you sure you want to delete this preset?</p>
			<button class="uk-margin-top uk-button uk-button-large" type="button" onclick="{ hideModal }">Cancel</button>
			<button class="uk-margin-top uk-button uk-button-danger uk-button-large" type="button" onclick="{ deletePreset }">Delete preset</button>
		</div>
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

		require('../../bower_components/uikit/js/core/modal')
		require('../../bower_components/uikit/js/components/notify')

		this.on('mount', (()=> {
			if ("" === self.refs.preset.value) {
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
			self.modal = UIkit.modal('#del-modal')
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
				return {value: addon, text: addon.name}
			})
			addonsInDir = window.multiselect.render({
				elementId: 'allAddon',
				data: addonData
			})
			const inPresetData = self.addonsInPreset.map((addon)=>{
				return {value: addon, text: addon.name}
			})
			addonsInPresetSelectbox = window.multiselect.render({
				elementId: 'presetAddon',
				data: inPresetData
			})
		}

		this.newPreset = ()=> {
			if ("" === self.refs.preset.value) {
				self.isNewPreset = true
				self.addonsInPreset = []
			} else {
				const fileName = self.refs.preset.value.replace(/ /g, '_') + '.json'
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
			let addonList
			try {
				addonList = self.loadAddonsLocal(config)
			} catch(e) {
				UIkit.notify('Mods folder not found!', {
					status:'danger',
					pos:'bottom-center',
					timeout:5000
				})
				console.error(e)
				return
			}
			const workshopItems = self.loadAddonsWorkshop(config)

			self.addons = []

			for (let addon of addonList) {
				self.addons.push(addon)
			}
			for (let item of workshopItems) {
				self.addons.push(item)
			}
			allAddonList = self.addons
			self.update()
		}

		this.loadAddonsLocal = (config)=> {
			let addonList = fs.readdirSync(config.mods_dir)
			addonList = addonList.filter((item)=>{
				return '@' === item.substring(0, 1)
			})
			addonList = addonList.map((item)=>{
				return {name: item, type: 'local'}
			})
			return addonList
		}

		this.loadAddonsWorkshop = (config)=> {
			let itemList = fs.readdirSync(config.a3dir + '/!Workshop')
			itemList = itemList.filter((item)=>{
				return '@' === item.substring(0, 1)
			})
			itemList = itemList.map((item)=>{
				return {name: item + ' (Steam workshop)', type: 'steam'}
			})
			return itemList
		}

		this.reloadAddon = ()=> {
			self.loadAddonsInA3Dir()
			self.diffAddons()
			self.updateSelectBox()
			UIkit.notify("Addons list was reloaded.", {
				status:'success',
				pos:'top-right',
				timeout:1000
			})
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
			for (let selected of selectedArr) {
				self.addonsInPreset = self.addonsInPreset.filter((v)=> {
					return v !== selected
				})
			}
			self.diffAddons()
			self.updateSelectBox()
			self.update()
		}

		this.upAddon = ()=> {
			const slctdKeyArr = addonsInPresetSelectbox.getSelectedIndexes()
			let addonArr = self.addonsInPreset
			for (let v of slctdKeyArr) {
				if (0 !== v) {
					[addonArr[v - 1], addonArr[v]] = [addonArr[v], addonArr[v - 1]]
				}
			}
			self.addonsInPreset = addonArr
			self.diffAddons()
			self.updateSelectBox()
			self.update()
		}

		this.downAddon = ()=> {
			const slctdKeyArr = addonsInPresetSelectbox.getSelectedIndexes()
			let addonArr = self.addonsInPreset
			for (let v of slctdKeyArr) {
				if (self.addonsInPreset.length - 1 !== v) {
					[addonArr[v], addonArr[v + 1]] = [addonArr[v + 1], addonArr[v]]
				}
			}
			self.addonsInPreset = addonArr
			self.diffAddons()
			self.updateSelectBox()
			self.update()
		}

		this.diffAddons = ()=> {
			self.addons = allAddonList
			for (let va of self.addonsInPreset) {
				self.addons = self.addons.filter((v)=> {
					return v.name !== va
				})
			}
		}

		this.savePreset = ()=> {
			let presetName = ''
			if ("" !== self.refs.preset.value) {
				const tgt = JSON.parse(fs.readFileSync(path.join(app.getAppPath(), 'preset/' + self.refs.preset.value + '.json'), 'utf-8'))
				presetName = tgt.name
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

			const steamItem = []

			const data = {
				name: presetName,
				addons: addons,
				steam: steamItem
			}
			const fileName = presetName.replace(/ /g, '_') + '.json'
			fs.writeFile(path.join(app.getAppPath(), 'preset/' + fileName), JSON.stringify(data, null, ' '), function(err) {
				if (err) {
					console.error(err)
					UIkit.notify('save failed', {
						status:'danger',
						pos:'bottom-center',
						timeout:800
					})
					return
				}
				UIkit.notify('save successed', {
					status:'success',
					pos:'bottom-center',
					timeout:800
				})
				self.update()
				window.setTimeout(()=>{
					self.loadPreset()
					self.newPreset()
					self.refs.newPresetName.value = ''
					self.update()
				}, 1000)
			})
		}

		this.showDelModal = ()=> {
			self.modal.show()
		}

		this.hideModal = ()=> {
			self.modal.hide()
		}

		this.deletePreset = ()=> {
			const targetPreset = self.refs.preset.value
			const fileName = targetPreset.replace(/ /g, '_') + '.json'
			fs.unlink(path.join(app.getAppPath(), 'preset/' + fileName), function(err) {
				self.modal.hide()
				if (err) {
					console.error(err)
					UIkit.notify('delete failed', {
						status:'danger',
						pos:'bottom-center',
						timeout:800
					})
					return
				}
				UIkit.notify('deleted', {
					status:'success',
					pos:'bottom-center',
					timeout:800
				})
				self.loadPreset()
				self.newPreset()
				self.refs.newPresetName.value = ''
				self.update()
			})
		}

	</script>
</addon>