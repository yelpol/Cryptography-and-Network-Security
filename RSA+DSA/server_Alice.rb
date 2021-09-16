#Alice
#serwer
require 'socket'
require 'openssl'


server = TCPServer.open(4567)
begin
  while client = server.accept
    #Klucz K do RSA
    rsa = OpenSSL::PKey::RSA.new(2048)
    pubkey_rsa = rsa.public_key
    puts "pubkey_rsa:\n" + pubkey_rsa.to_s
    client.puts(pubkey_rsa.to_s.length)
    client.puts(pubkey_rsa)

    #Klucz K do DSA
    dsa = OpenSSL::PKey::DSA.new(2048)
    pubkey_dsa = dsa.public_key
    puts "pubkey_dsa:\n" + pubkey_dsa.to_s
    client.puts(pubkey_dsa.to_s.length)
    client.puts(pubkey_dsa)

    #Podpis pub_key_rsa w DSA
    digest = OpenSSL::Digest::SHA1.digest(pubkey_rsa.to_s.chomp)
    sig = dsa.syssign(digest)
    puts "sig: " + sig.to_s
    client.puts(sig.length)
    client.puts(sig)

    #pobieranie C
    encrypted_len = client.gets().to_i
    encrypted = client.gets()
    while (encrypted.to_s.length < encrypted_len)
      encrypted = encrypted + client.gets()
    end
    encrypted = encrypted.chomp
    puts "encrypted: " + encrypted.to_s

    #obliczenie M
    plain = rsa.private_decrypt(encrypted).force_encoding('UTF-8')
    puts "wiadomość od Boba: " + plain

    client.close
    break
end
rescue Errno::ECONNRESET, Errno::EPIPE => e
  puts e.message
  retry
end
