<play>
	<form class="uk-form uk-form-horizontal">
		<div class="uk-form-row">
			<label class="uk-form-label">Select preset</label>
			<div class="uk-form-controls">
				<select>
					<option value="">no addon</option>
				</select>
			</div>
		</div>
		<button class="uk-button uk-button-primary launch-button" type="button" onclick="{ launchGame }">Arma3 launch</button>
	</form>

	<style type="scss">
		.launch-button{
			padding: 30px;
			margin-top: 50px;
			font-size: 32px;
		}
	</style>

	<script type="es6">
		const self = this

		this.launchGame = function() {
			// body...
		}
	</script>
</play>