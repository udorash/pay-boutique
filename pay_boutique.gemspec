lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pay_boutique/version'

Gem::Specification.new do |spec|
  spec.name          = 'pay_boutique'
  spec.version       = PayBoutique::VERSION
  spec.authors       = ['Yuri Zubov', 'Alexandr Senyuk']
  spec.email         = ['I0Result86@gmail.com']
  spec.homepage      = 'https://github.com/SumatoSoft/pay-boutique'

  spec.summary       = 'Payment system PayBoutique'
  spec.description   = 'Very simple wrapper for payment system PayBoutique'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.' unless spec.respond_to?(:metadata)

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  spec.files                         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir                        = 'exe'
  spec.executables                   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths                 = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'rake', '~> 10.0'

  spec.add_runtime_dependency 'activesupport', '>= 4.2.0'
  spec.add_runtime_dependency 'httparty', '>= 0.7.7'
  spec.add_runtime_dependency 'nokogiri', '>= 1.5.0'
end
