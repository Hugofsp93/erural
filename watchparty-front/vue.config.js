module.exports = {
  chainWebpack: (config) => {
    config.module
      .rule('fonts')
      .test(/\.(woff2?|eot|ttf|otf)(\?.*)?$/i)
      .use('file-loader')
      .loader('file-loader')
      .options({
        name: 'fonts/[name].[ext]',
      });
  },
};