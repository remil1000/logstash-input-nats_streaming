# encoding: utf-8
require "logstash/inputs/base"
require "logstash/namespace"
require "stud/interval"
require "socket"
require "stan/client"

class LogStash::Inputs::NatsStreaming < LogStash::Inputs::Base
  config_name "nats_streaming"

  default :codec, "json"

  config :servers, :validate => :array, :default => [ "nats://localhost:4222" ]
  config :cluster, :validate => :string, :required => true
  config :subject, :validate => :string, :required => true
  config :clientid, :validate => :string, :default => Socket.gethostname
  config :interval, :validate => :number, :default => 60
  config :durable_name, :validate => :string, :default => "#{Socket.gethostname}-durable"
  config :unsubscribe, :validate => :boolean, :default => false
  config :nats_meta, :validate => :boolean, :default => true
  #TODO config queue_group string

  public
  def register
    @host = Socket.gethostname
    @sc = STAN::Client.new
    opts = { servers: @servers }
    @sc.connect(@cluster, @clientid, nats: opts)
  end

  def run(queue)
    @sc.subscribe(@subject, durable_name: @durable_name) do |msg|
      line = msg.data.chomp + "\n"
      @codec.decode(line) do |event|
        event.set("host", @host)
        if @nats_meta
          event.set("nats_clientid", @clientid)
          event.set("nats_subject", @subject)
          event.set("nats_cluster", @cluster)
        end
        decorate(event)
        queue << event
      end
    end
    while !stop?
      Stud.stoppable_sleep(@interval) { stop? }
    end
  end

  def stop
    if @unsubscribe
      @sub.unsubscribe
    end
    @sc.close
  end
end
