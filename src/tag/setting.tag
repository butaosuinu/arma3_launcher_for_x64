<setting>
	<form class="uk-form uk-form-horizontal">
		<div class="uk-form-row">
			<label class="uk-form-label">Arma3 client</label>
			<div class="uk-form-controls">
				<select>
					<option value="64">64 bit</option>
					<option value="32">32 bit</option>
				</select>
			</div>
		</div>
		<div class="uk-form-row">
			<label class="uk-form-label">Arma3 path</label>
			<div class="uk-form-controls">
				<input class="uk-width-1-2" type="text" name="" value=""><button class="uk-button" type="button" onclick="{ selectA3Folder }">browse</button>
			</div>
		</div>
		<div class="uk-form-row">
			<label class="uk-form-label">launch options</label>
			<div class="uk-form-controls">
				<input class="uk-width-1-2" type="text" name="" value="">
			</div>
		</div>
		<button class="uk-margin-top uk-button uk-button-primary uk-button-large" type="button" onclick="{ save }">Save</button>
	</form>

	<script type="es6">
		const fs = require('fs')
		const remote = require('electron').remote
		const dialog = remote.dialog
		const browserWindow = remote.BrowserWindow
		const self = this

		this.selectClient = function() {
			// body...
		}

		this.selectA3Folder = function() {
			// body...
		}

		this.save = function() {
			// body...
		}
	</script>
</setting>