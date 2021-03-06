var webpack = require('webpack');
var path = require('path')

var commonsPlugin = new webpack.optimize.CommonsChunkPlugin('common');
var JsonpTemplatePlugin = webpack.JsonpTemplatePlugin;
var FunctionModulePlugin = require('webpack/lib/FunctionModulePlugin');
var NodeTargetPlugin = require('webpack/lib/node/NodeTargetPlugin');
var ExternalsPlugin = webpack.ExternalsPlugin;
var ExtractTextPlugin = require('extract-text-webpack-plugin');

module.exports = [{
  entry: {
    main: './src/js/render.js',
  },
  output: {
    path: __dirname + '/app/render',
    filename: '[name].js'
  },
  plugins: [
    new webpack.ProvidePlugin({ riot: 'riot' }),
    new webpack.NoErrorsPlugin(),
    new ExternalsPlugin('commonjs', [
      'electron',
      'app',
      'auto-updater',
      'browser-window',
      'content-tracing',
      'dialog',
      'global-shortcut',
      'ipc',
      'menu',
      'menu-item',
      'power-monitor',
      'protocol',
      'tray',
      'remote',
      'web-frame',
      'clipboard',
      'crash-reporter',
      'screen',
      'shell'
    ]),
    new NodeTargetPlugin()
    // commonsPlugin
  ],
  module: {
    rules: [
      {
        test: /\.tag$/,
        enforce: "pre",
        exclude: /node_modules/,
        use: {
          loader: 'riotjs-loader',
          query: {
            type: ['babel', 'scss']
          }
        }
      },
      {
        test: /\.js$|\.tag$/,
        exclude: /node_modules/,
        use: 'babel-loader',
        use: {
          loader: 'babel-loader',
          query: {
            presets: ['latest']
          }
        }
      }
    ]
  },
  resolve: {
    modules: ['node_modules', 'bower_components'],
    descriptionFiles: ['package.json', 'bower.json'],
    extensions: ['.js', '.tag'],
    alias: {
      uikit: 'uikit/js/uikit.js',
      components: 'bower_components/uikit/js/components'
    }
  }
}, {
  entry: {
    main: './src/sass/main.scss'
  },
  output: {
    path: path.join(__dirname + '/app/render/css'),
    filename: '[name].css'
  },
  plugins: [
    new ExtractTextPlugin('[name].css'),
  ],
  module: {
    rules: [
      {
        test: /\.scss$/,
        use: ExtractTextPlugin.extract({
          fallback: "style-loader",
          use: "css-loader!sass-loader"
        })
      },
      {
        test: /\.(otf|eot|svg|ttf|woff|woff2)(\?.+)?$/,
        use: 'url-loader'
      }
    ]
  }
}];
