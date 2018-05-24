# Logstash Plugin

This is a plugin for [Logstash](https://github.com/elastic/logstash).

It is fully free and fully open source. The license is Apache 2.0, meaning you
are pretty much free to use it however you want in whatever way.

Input plugin for [NATS Streaming](https://nats.io/documentation/streaming/nats-streaming-intro/)

## Documentation

Uses ruby-nats-streaming library:

- https://github.com/nats-io/ruby-nats-streaming
- https://nats.io/documentation/streaming/nats-streaming-intro/

### Options

Available options (see NATS.io and ruby-nats-streaming for usage):

- servers, array default `[ "nats://localhost:4222" ]`
- cluster, string required
- subject, string required
- clientid, string default `Socket.gethostname (hostname)`
- interval, number default 60
- durable_name, string default ""
- unsubscribe, boolean default false
- queue_group, string default ""
- start_at, string default "first"
- max_inflight, number default 1024
- ack_wait, number default 30
- sequence, number no default value
- nats_meta, boolean default true (include nats_clientid nats_subject nats_cluster in the output event)

### Configuration example:

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
gpg --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable

source /etc/profile.d/rvm.sh

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
```

### 2. Running your unpublished Plugin in Logstash

- Build your plugin gem
```sh
gem build logstash-input-nats_streaming.gemspec
```
- Install the plugin from the Logstash home, example:
```sh
bin/logstash-plugin install logstash-input-nats_streaming-0.2.0.gem
```
- Start Logstash and proceed to test the plugin

## Contributing

Contributions, feature requests and bug reports are welcome
