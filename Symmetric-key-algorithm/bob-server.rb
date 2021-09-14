#serwer
require 'socket'
require 'openssl'

fileout = "file_org.pdf"

server = TCPServer.open(4567)
begin
  while client = server.accept
    #wybor protokolu
    puts client.gets
    protokol = gets
    client.puts(protokol)

    #DH protokol
    der = client.gets
    while (der.length < 269)
      der = der + client.gets
    end
    der = der.chomp
    dh2 = OpenSSL::PKey::DH.new(der)
    dh2.generate_key!
    #puts "p=" + dh2.p.to_s
    #puts "g=" + dh2.g.to_s
    #puts "y=" + dh2.pub_key.to_s
    #puts "x=" + dh2.priv_key.to_s
    client.puts(dh2.pub_key)

    dh1_pk = client.gets.to_i
    symm_key2 = dh2.compute_key(dh1_pk)
    puts "sekret = " + symm_key2

    #deszyfrowanie
    if (protokol.chomp == "1")
      decipher = OpenSSL::Cipher.new('des')
      decipher.decrypt
      decipher.key = symm_key2.to_s[1..8]
      iv = client.gets.chomp
      decipher.iv = iv
      encrypted_l = client.gets.chomp.to_i
      encrypted = client.gets
      while (encrypted.length < encrypted_l)
        encrypted = encrypted + client.gets
      end
      encrypted = encrypted.chomp
      plain = ''
      plain << decipher.update(encrypted)
      plain << decipher.final
    else
      decipher = OpenSSL::Cipher::AES.new(128, :CBC)
      decipher.decrypt
      decipher.key = symm_key2.to_s[1..16]
      iv = client.gets.chomp
      decipher.iv = iv
      encrypted_l = client.gets.chomp.to_i
      encrypted = client.gets
      while (encrypted.length < encrypted_l)
        encrypted = encrypted + client.gets
      end
      encrypted = encrypted.chomp
      plain = ''
      plain << decipher.update(encrypted)
      plain << decipher.final
    end
    file = File.open(fileout, 'w+')
    file.write plain
    client.close
    break
end
rescue Errno::ECONNRESET, Errno::EPIPE => e
  puts e.message
  retry
end
