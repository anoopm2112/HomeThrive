const path = require('path')

const envPath = path.resolve(__dirname, '.env')
require('dotenv').config({
  path: envPath,
})

module.exports = {
  trailingSlash: true,
  webpack: (config, options) => {
    // sets up ~ alias
    config.resolve = config.resolve || {}
    config.resolve.alias = {
      ...(config.resolve && config.resolve.alias ? config.resolve.alias : {}),
      '~': path.resolve(__dirname, './src'),
    }

    // loads SVG images
    config.module = config.module || {}
    config.module.rules = config.module.rules || []
    config.module.rules.push({
      test: /\.svg$/,
      use: ['@svgr/webpack'],
    })

    // loads fonts
    config.module.rules.push({
      test: /\.(ttf|eot|woff|woff2)$/,
      use: [
        {
          loader: 'file-loader',
        },
      ],
      // options: {
      //   name: 'src/lib/assets/fonts/[name].[ext]'
      // }
    })

    config.stats = {
      warningsFilter: [/makeStyles/],
    }

    // add plugins
    config.plugins = config.plugins || []

    return config
  },
}
