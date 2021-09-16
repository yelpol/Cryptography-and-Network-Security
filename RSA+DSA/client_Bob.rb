#Bob
#klient
require 'openssl'
require 'socket'

host = '150.254.79.243'#'150.254.76.198'
port = 4567

socket = TCPSocket.open(host, port)
begin
  while true

    #pobieranie Alice pubkey_rsa
    pubkey_rsa_len = socket.gets().to_i

    pubkey_rsa = socket.gets()
    while (pubkey_rsa.to_s.length < pubkey_rsa_len)
      pubkey_rsa = pubkey_rsa + socket.gets()
    end
    pubkey_rsa = pubkey_rsa.chomp
    puts "pubkey_rsa:\n" + pubkey_rsa.to_s

    #pobieranie Alice pubkey_dsa
    pubkey_dsa_len = socket.gets().to_i

    pubkey_dsa = socket.gets()
    while (pubkey_dsa.to_s.length < pubkey_dsa_len)
      pubkey_dsa = pubkey_dsa + socket.gets()
    end
    pubkey_dsa = pubkey_dsa.chomp
    puts "pubkey_dsa:\n" + pubkey_dsa.to_s

    #pobieranie Alice sig
    sig_len = socket.gets().to_i

    sig = socket.gets()
    while (sig.to_s.length < sig_len)
      sig = sig + socket.gets()
    end
    sig = sig.chomp
    puts "sig: " + sig.to_s

    #weryfikacja
    digest = OpenSSL::Digest::SHA1.digest(pubkey_rsa)
    dsa = OpenSSL::PKey::DSA.new(pubkey_dsa)
    puts dsa.sysverify(digest, sig)

    #ustalenie M i obliczenie C
    print("Proszę podać wiadomość do szyfrowania\n")
    plain = gets
    rsa = OpenSSL::PKey::RSA.new(pubkey_rsa)
    encrypted = rsa.public_encrypt(plain);
    puts "encrypted: " + encrypted.to_s

    #wysylanie C
    socket.puts(encrypted.length)
    socket.puts(encrypted)


    break
end
rescue Errno::ECONNRESET, Errno::EPIPE => e
  puts e.message
  retry
end
