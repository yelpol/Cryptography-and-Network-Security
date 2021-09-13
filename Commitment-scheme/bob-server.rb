#serwer
require 'socket'
require 'openssl'

def check(random_A, random_A1, random_B, random_b, hash)
    data = random_A.chomp + random_B.chomp + random_b.chomp
    sha256 = OpenSSL::Digest::SHA256.new
    h = sha256.digest(data)
    puts "Y': " + h
    if ((random_A == random_A1) and (h == hash.chomp))
      return 0
    else
      return 1
    end
end

server = TCPServer.open(4567)
begin
  while client = server.accept
    random_A = client.gets
    puts "A: " + random_A
    hash = client.gets
    while (hash.length < 32)         #czasami hash zawiera znak nowej linii, więc program sprawdza długość, i w razie potrzeby dolepia do wcześniejszej wiadomości
      hash = hash + client.gets
    end
    puts "Y: " + hash
    random_A1 = client.gets
    puts "A': " + random_A1
    random_B = client.gets
    puts "B: " + random_B
    random_b = client.gets
    puts "b: " + random_b
    result = check(random_A, random_A1, random_B, random_b, hash)
    if (result == 0)
      client.puts("Uznaje bit")
    else
      client.puts("Nie uznaje bitu")
    end
    client.close
    break
end
rescue Errno::ECONNRESET, Errno::EPIPE => e
  puts e.message
  retry
end
