Gem::Specification.new do |s|
  s.name          = 'logstash-input-nats_streaming'
  s.version       = '0.1.2'
  s.licenses      = ['Apache-2.0']
  s.summary       = 'nats streaming input plugin'
  s.homepage      = 'http://www.data-essential.com/'
  s.authors       = ['Rémi Laurent']
  s.email         = 'remi.laurent@data-essential.com'
  s.require_paths = ['lib']

  # Files
  s.files = Dir['lib/**/*','spec/**/*','vendor/**/*','*.gemspec','*.md','CONTRIBUTORS','Gemfile','LICENSE','NOTICE.TXT']
   # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "input" }

  # Gem dependencies
  s.add_runtime_dependency "logstash-core-plugin-api", "~> 2.0"
  s.add_runtime_dependency 'logstash-codec-plain'
  s.add_runtime_dependency 'stud', '>= 0.0.22'
  s.add_runtime_dependency 'nats-streaming', '>= 0.2.2'
  s.add_runtime_dependency 'google-protobuf', '= 3.1.0'
  s.add_development_dependency 'logstash-devutils', '>= 0.0.16'
end
