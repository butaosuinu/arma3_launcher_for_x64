const {app, BrowserWindow, nativeImage} = require('electron')
const path = require('path')
const url = require('url')

let win

let appIcon = nativeImage.createFromPath(path.join(__dirname, 'image', 'main_icon.png'))

function createWindow() {
	win = new BrowserWindow({width: 980, height: 720, minWidth: 980, minHeight: 720, icon: appIcon})
	win.loadURL(url.format({
		pathname: path.join(__dirname, 'index.html'),
		protocol: 'file:',
		slashes: true
	}))

	win.on('close', () => {
		win = null
	})
}

app.on('ready', createWindow)

app.on('window-all-closed', () => {
	if (process.platform !== 'dawin') {
		app.quit()
	}
})

app.on('activate', () => {
	if (win === null) {
		createWindow()
	}
})
