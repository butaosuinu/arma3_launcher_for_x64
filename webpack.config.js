var webpack = require('webpack');

var commonsPlugin = new webpack.optimize.CommonsChunkPlugin('common');

module.exports = {
	entry: {
		main: './src/js/render.js',
	},
	output: {
		path: __dirname + '/app/render',
		filename: '[name].js'
	},
	plugins: [
		new webpack.ProvidePlugin({ riot: 'riot' }),
		commonsPlugin
		// new webpack.optimize.UglifyJsPlugin()
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
			}
		]
	},
	resolve: {
		extensions: ['.js', '.tag']
	}
};
