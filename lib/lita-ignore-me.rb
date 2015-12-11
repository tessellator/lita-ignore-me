require "lita"

Lita.load_locales Dir[File.expand_path(
  File.join("..", "..", "locales", "*.yml"), __FILE__
)]

require "lita/ignore_registry"
require "lita/extensions/ignore_me"
require "lita/handlers/ignore_me"
