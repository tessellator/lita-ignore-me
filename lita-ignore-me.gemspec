Gem::Specification.new do |spec|
  spec.name          = "lita-ignore-me"
  spec.version       = "0.2.0"
  spec.authors       = ["Chad Taylor"]
  spec.email         = ["taylor.thomas.c@gmail.com"]
  spec.description   = %q{A Lita extension to ignore a user's non-command messages upon request.}
  spec.summary       = %q{A Lita extension that allows a user to tell the robot to ignore him or her unless that user addresses the robot directly.}
  spec.homepage      = "https://github.com/tessellator/lita-ignore-me"
  spec.license       = "MIT"
  spec.metadata      = { "lita_plugin_type" => "extension" }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita", "~> 4.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rspec", ">= 3.0.0"
end
