// our webpack.config.js file located in project root
//DONT TOUCH THIS
var webpack = require('webpack');
var path = require('path');
var ExtractTextPlugin = require("extract-text-webpack-plugin")

module.exports = {
  entry: [
    './web/static/css/app.css',
    "./web/static/js/app.js"],
  output: {
    path: "./priv/static",
    filename: "js/bundle.js"
  },                // the entry point for our app
  resolve: {
    root: [
      path.resolve(__dirname, './web/static/js')
    ],
    extensions: ['', '.js', '.json', '.jsx']
  },
  module: {
    loaders: [
      { test: /\.js$/,
        loader: 'babel-loader',
        exclude: /(node_modules|bower_components)/
      },
      { test: /\.css$/, loader: ExtractTextPlugin.extract("style", "css")}
    ]
  },
  plugins: [
    new ExtractTextPlugin("css/app.css")
  ]
};
