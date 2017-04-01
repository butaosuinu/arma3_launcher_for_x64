<addon>
	<form class="uk-form uk-form-horizontal">
		<div class="uk-form-row">
			<label class="uk-form-label">Select preset</label>
			<div class="uk-form-controls">
				<select ref="preset" onchange="{ newPreset }">
					<option value="0"> - new preset - </option>
					<option value="1"> - preset - </option>
				</select>
			</div>
		</div>
		<div class="uk-form-row" if={ isNewPreset }>
			<label class="uk-form-label">preset name</label>
			<div class="uk-form-controls">
				<input class="uk-width-1-2" type="text" name="" value="">
			</div>
		</div>
		<div class="uk-form-row uk-width-3-4 uk-grid">
			<div class="uk-width-1-2">
				<div>
					<select class="addon-area" name="" multiple>
						<option value=""></option>
					</select>
				</div>
				<button class="uk-button">add</button>
			</div>
			<div class="uk-width-1-2">
				<div>
					<select class="addon-area" name="" multiple>
						<option value=""></option>
					</select>
				</div>
				<button class="uk-button">remove</button>
			</div>
		</div>
		<button class="uk-margin-top uk-button uk-button-primary uk-button-large" type="button" onclick="{ savePreset }">Save preset</button>
		<button class="uk-margin-top uk-button uk-button-large" type="button">Cancel</button>
		<button class="uk-margin-top uk-button uk-button-danger uk-button-large" type="button">Delete preset</button>
	</form>

	<style type="scss">
		.addon-area{
			width: 100%;
			height: 270px !important;
		}
		
	</style>

	<script type="es6">
		const fs = require('fs')
		const common = require('../js/utilService.js')
		const self = this

		this.on('mount', (function () {
			if (0 == self.refs.preset.value) {
				self.isNewPreset = true
			} else {
				self.isNewPreset = false
			}
			self.update()
		}))

		this.newPreset = function() {
			if (0 == self.refs.preset.value) {
				self.isNewPreset = true
			} else {
				self.isNewPreset = false
			}
			self.update()
		}

		this.addAddon = function() {
			// body...
		}

		this.removeAddon = function() {
			// body...
		}

		this.savePreset = function() {
			// body...
		}

		this.deletePreset = function() {
			// body...
		}

	</script>
</addon>