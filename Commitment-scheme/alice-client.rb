#klient
require 'openssl'
require 'securerandom'
require 'socket'

host = '150.254.79.243'
port = 4567

random_b = SecureRandom.random_number(2).to_s
puts "b: " + random_b

random_A = SecureRandom.alphanumeric(20)
puts "A: " + random_A

random_B = SecureRandom.alphanumeric(20)
puts "B: " + random_B

data = random_A + random_B + random_b
sha256 = OpenSSL::Digest::SHA256.new
hash = sha256.digest(data)
puts "Y: " + hash

socket = TCPSocket.open(host, port)
begin
  while true
    socket.puts(random_A)
    socket.puts(hash)
    socket.puts(random_A)
    socket.puts(random_B)
    socket.puts(random_b)
    answer = socket.gets
    puts answer
    break
end
rescue Errno::ECONNRESET, Errno::EPIPE => e
  puts e.message
  retry
end
