# Arma3 game launcher for x64 client

This is a game launcher for Arma3 64bit client.  
This app made with electron, Riot.js and Uikit css framework.  

[App download](https://github.com/butaosuinu/arma3_launcher_for_x64/releases)

## feature

- x64 client support
- Addon manager
- launch options


## for developer

This is a electron app. So, you need electron npm package.  

### Requirement

- Node.js v6.0+
- electron v1.6.2
- electron-packager
- (When you build this app with Mac) wine

### install

```
$ npm i -g electron electron-packager
$ git clone https://github.com/butaosuinu/arma3_launcher_for_x64.git
$ cd arma3_launcher_for_x64/
$ npm i
$ bower install
$ npm run total-build-win # when your machine is unix/linux, you can use "npm run total-build-unix"

or

$ npm build-dev
$ electron ./app
```

enjoy!

## credit

- butaosuinu : planning, coding and etc
- raika siray : icon image
