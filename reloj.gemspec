# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'reloj/version'

Gem::Specification.new do |spec|
  spec.name          = "reloj"
  spec.version       = Reloj::VERSION
  spec.authors       = ["ougarcia"]
  spec.email         = ["oz.ulysses@gmail.com"]

  spec.summary       = %q{A lightewieght mvc framework inspired by Ruby on Rails}
  spec.description   = %q{A lightewieght mvc framework inspired by Ruby on Rails. Try it out!}
  spec.homepage      = "https://github.com/ougarcia/reloj"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features|app)/})
  end
  spec.executables   = ["reloj"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.3"
  spec.add_development_dependency "byebug", "~> 6.0"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_runtime_dependency "webrick", "~> 1.3"
  spec.add_runtime_dependency "activesupport", "~> 4.2"
  spec.add_runtime_dependency "require_all", "~> 1.3"
  spec.add_runtime_dependency "sqlite3", "~> 1.3"
  spec.add_runtime_dependency "pg", "~> 0.18"

end
