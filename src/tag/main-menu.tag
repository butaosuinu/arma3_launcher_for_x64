<main-menu>
	<ul class="uk-tab" onclick="{ clickTab }">
		<li class="{ url === '' ? 'uk-active' : '' }"><a href="#">home</a></li>
		<li class="{ url === '#addon' ? 'uk-active' : '' }"><a href="#addon">addon setting</a></li>
		<li class="{ url === '#setting' ? 'uk-active' : '' }"><a href="#setting">general setting</a></li>
	</ul>

	<script type="es6">
		const self = this
		this.on('mount', (() => {
			self.url = location.hash
			self.update()
		}))
	</script>
</main-menu>