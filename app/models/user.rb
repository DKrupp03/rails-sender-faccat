class User < ApplicationRecord
  after_create do
    channel = $bunny_connection.create_channel
    queue = channel.queue('users')
    channel.default_exchange.publish(
      self.as_json(only: [:id, :name, :email]).to_json,
      routing_key: queue.name
    )
  end
end
