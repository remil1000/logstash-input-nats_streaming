# Logstash Plugin

This is a plugin for [Logstash](https://github.com/elastic/logstash).

It is fully free and fully open source. The license is Apache 2.0, meaning you
are pretty much free to use it however you want in whatever way.

Input plugin for [NATS Streaming](https://nats.io/documentation/streaming/nats-streaming-intro/)

## Documentation

Configuration example:

```ruby
input {
	nats_streaming {
		#codec => "plain"
		servers => [ "nats://localhost:4222" ]
		cluster => "test-cluster"
		subject => "mysubject"
    #clientid => "myclientid"
    #durable_name => "durable"
	}
}

output {
	stdout {
		codec => rubydebug
	}
}
```

## Developing

### 1. Plugin Developement and Testing

#### Code

- To get started, you'll need JRuby (we'll use RVM, adapt GPG key id if needed)

```sh
curl -sSL https://get.rvm.io | bash -s stable
gpg --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3

rvm install jruby
rvm use jruby
```

- Then install bundler and run it on our plugin repo

```sh
gem install bundler
bundle install
```

- Build our Gem

```sh
gem build logstash-input-nats_streaming.gemspec
gem install bundler
bundle install
```

### 2. Running your unpublished Plugin in Logstash

- Build your plugin gem
```sh
gem build logstash-input-nats_streaming.gemspec
```
- Install the plugin from the Logstash home, example:
```sh
bin/logstash-plugin install logstash-input-nats_streaming-0.1.0.gem
```
- Start Logstash and proceed to test the plugin

## Contributing

Contributions, feature requests and bug reports are welcome
