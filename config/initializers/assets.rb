# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path

# Configure Sprockets to handle spaces in paths
Rails.application.config.assets.configure do |env|
  env.cache = Sprockets::Cache::FileStore.new(
    ENV.fetch("SPROCKETS_CACHE", "tmp/cache/assets"),
    Rails.application.config.assets.cache_limit,
    env.logger
  )
end

# Precompile additional assets
Rails.application.config.assets.precompile += %w( *.js *.css *.scss *.sass *.png *.jpg *.jpeg *.gif *.svg *.eot *.woff *.ttf )
