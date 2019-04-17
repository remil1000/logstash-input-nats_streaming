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
	config :durable_name, :validate => :string, :default => ""
	config :unsubscribe, :validate => :boolean, :default => false
	config :nats_meta, :validate => :boolean, :default => true
	config :queue, :validate => :string, :default => ""
	config :start_at, :validate => :string, :default => "new_only"
	config :max_inflight, :validate => :number, :default => 1024
	config :ack_wait, :validate => :number, :default => 30
	config :sequence, :validate => :number

	public
	def register
		start_at_values = %w{new_only last_received sequence first beginning}
		@host = Socket.gethostname
		@sc = STAN::Client.new
		opts = { servers: @servers }
		@sc.connect(@cluster, @clientid.split(".").first, nats: opts)
		@subscribe_opts = {
			:max_inflight => @max_inflight,
			:ack_wait => @ack_wait
		}
		@subjects = @subject.split(",").map(&:strip).uniq
		@subjects.delete("") # .delete() is a side effect function
		unless @queue.empty?
			@subscribe_opts[:queue] = @queue
		end
		unless @durable_name.empty?
			@subscribe_opts[:durable_name] = @durable_name
		end
		unless @sequence.nil?
			@subscribe_opts[:sequence] = @sequence
		end
		unless @start_at.empty?
			if start_at_values.include?(@start_at)
				@subscribe_opts[:start_at] = @start_at.to_sym
			else
				@subscribe_opts[:start_at] = :first
			end
		end
	end

	def run(queue)
		@subjects.each do |subject|
			@sc.subscribe(subject, @subscribe_opts) do |msg|
				line = msg.data.chomp + "\n"
				@codec.decode(line) do |event|
					event.set("host", @host)
					if @nats_meta
						event.set("nats_clientid", @clientid)
						event.set("nats_subject", subject)
						event.set("nats_cluster", @cluster)
					end
					decorate(event)
					queue << event
				end
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
