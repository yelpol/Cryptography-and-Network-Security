#klient
require 'openssl'
require 'socket'

#DH protokol
def dhProtokol(socket)
  dh1 = OpenSSL::PKey::DH.new(2048)
  #puts "p=" + dh1.p.to_s
  #puts "g=" + dh1.g.to_s
  #puts "y=" + dh1.pub_key.to_s
  #puts "x=" + dh1.priv_key.to_s
  der = dh1.public_key.to_der
  socket.puts(der)

  dh2_pk = socket.gets.to_i
  socket.puts(dh1.pub_key)
  symm_key1 = dh1.compute_key(dh2_pk)

  return symm_key1
end

host = '150.254.79.243' #'150.254.76.198'
port = 4567

socket = TCPSocket.open(host, port)
begin
  while true
    socket.puts("Jeśli chcesz stosować szyfr DES, wybierz 1. Jeśli chcesz stosować szyfr AES_128_CBC, wybierz 2.");
    if (socket.gets.chomp == "1")
      puts "Wybrano DES"

      symm_key1 = dhProtokol(socket)
      puts "sekret = " + symm_key1

      #szyfrowanie
      file = File.open(ARGV[0]).read
      cipher = OpenSSL::Cipher.new('des')
      cipher.encrypt
      cipher.key = symm_key1.to_s[1..8]
      iv = cipher.random_iv
      socket.puts(iv)
      encrypted = ''
      encrypted << cipher.update(file)
      encrypted << cipher.final
      socket.puts(encrypted.length)
      socket.puts(encrypted)
    else
      puts "Wybrano AES_128_CBC"

      symm_key1 = dhProtokol(socket)
      puts "sekret = " + symm_key1

      #szyfrowanie
      file = File.open(ARGV[0]).read
      cipher = OpenSSL::Cipher.new('AES-128-CBC')
      cipher.encrypt
      cipher.key = symm_key1.to_s[1..16]
      iv = cipher.random_iv
      socket.puts(iv)
      encrypted = ''
      encrypted << cipher.update(file)
      encrypted << cipher.final
      socket.puts(encrypted.length)
      socket.puts(encrypted)
    end
    break
end
rescue Errno::ECONNRESET, Errno::EPIPE => e
  puts e.message
  retry
end
