<setting>
	<main-menu></main-menu>
	<div class="uk-margin-top">
	<form class="uk-form uk-form-horizontal">
		<div class="uk-form-row">
			<label class="uk-form-label">Arma3 client</label>
			<div class="uk-form-controls">
				<select ref="A3client">
					<option value="64">64 bit</option>
					<option value="32">32 bit</option>
				</select>
			</div>
		</div>
		<div class="uk-form-row">
			<label class="uk-form-label">Arma3 path</label>
			<div class="uk-form-controls">
				<input class="uk-width-1-2" type="text" name="" value="" ref="A3Folder"><button class="uk-button" type="button" onclick="{ selectA3Folder }">browse</button>
			</div>
		</div>
		<div class="uk-form-row">
			<label class="uk-form-label">launch options</label>
			<div class="uk-form-controls">
				<input class="uk-width-1-2" type="text" ref="A3options">
			</div>
		</div>
		<button class="uk-margin-top uk-button uk-button-primary uk-button-large" type="button" onclick="{ saveConfig }">Save</button>
		<p class="uk-text-success" if="{ isSave }">save successed</p>
	</form>
	</div>

	<script type="es6">
		const fs = require('fs')
		const path = require('path')
		const {dialog, BrowserWindow, app} = require('electron').remote
		const common = require('../js/utilService.js')
		const self = this

		this.on('mount', (function () {
			self.loadConfig()
			self.isSave = false
			self.update()
		}))

		this.loadConfig = function() {
			const config = common.loadConfigFile()
			self.refs.A3client.value = config.client
			self.refs.A3Folder.value = config.a3dir
			self.refs.A3options.value = config.option
			self.update()
		}

		this.selectA3Folder = function() {
			const focusedWindow = BrowserWindow.getFocusedWindow()
			dialog.showOpenDialog(focusedWindow, {
				properties: ['openDirectory']
			}, function(dir) {
				if (undefined !== dir) {
					self.refs.A3Folder.value = dir
				}
				self.update()
			})
		}

		this.saveConfig = function() {
			const client = parseInt(self.refs.A3client.value)
			const dir = self.refs.A3Folder.value
			const option = self.refs.A3options.value
			const data = {
				client: client,
				a3dir: dir,
				option: option
			}
			fs.writeFile(path.join(app.getAppPath(), 'config.json'), JSON.stringify(data, null, ' '), function(err) {
				if (err) {
					console.log(err)
					return
				}
				self.isSave = true
				self.update()
				window.setTimeout(function(){
					self.isSave = false
					self.update()
				}, 1000)
			})
		}
	</script>
</setting>