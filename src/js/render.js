const jquery = require('jquery')
const riot   = require('riot')

// tags
require('../tag/addon.tag')
require('../tag/play.tag')
require('../tag/setting.tag')
require('../tag/main-menu.tag')

// routing
const Router = require('riot-router')

const Route         = Router.Route
const DefaultRoute  = Router.DefaultRoute
const NotFoundRoute = Router.NotFoundRoute
const RedirectRoute = Router.RedirectRoute

router.routes([
	new DefaultRoute({tag: 'play'}),
	new Route({path: 'setting', tag: 'setting'}),
	new Route({path: 'addon', tag: 'addon'}),
	new NotFoundRoute({tag: 'play'})
])


riot.mount('*')
router.start()
