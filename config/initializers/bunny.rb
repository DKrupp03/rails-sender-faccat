require 'bunny'

$bunny_connection = Bunny.new(hostname: 'rabbitmq', username: 'guest', password: 'guest')
$bunny_connection.start
