#Bob
#client
require 'openssl'
require 'socket'

def text_to_int(text)
  bitmap = '1'+text.unpack('B*')[0]
	bitmap.to_i(2)
end

def int_to_text(int)
	bitmap = int.to_i.to_s(2)
	[bitmap.sub(/^1/, '')].pack('B*')
end


def unblind(blinded_msg, k, key)
  msg_int = blinded_msg * k.to_bn.mod_exp(key.e, key.n).mod_inverse(key.n) % key.n
  return msg_int
end

def sign(msg, key)
  # z = y^d (mod n)
  msg.to_bn.mod_exp(key.d, key.n) % key.n
end

host = '150.254.79.243'#'150.254.76.198'
port = 4567
socket = TCPSocket.open(host, port)
begin
  while true
		#Tworzy klucz
		key = OpenSSL::PKey::RSA.new(2048)
		# puts"public key: #{key}"

    #Wysyła klucz do Alice
		socket.puts(key.to_s.length)
		socket.puts(key)


    #Odbiera yi, i = 1..100
    msgs_int_blinded_len = socket.gets().to_i
    # puts"len: #{msgs_int_blinded_len}"
    msgs_int_blinded = Array.new
    msg_b = socket.gets().chomp.to_i
    msgs_int_blinded.append(msg_b)
    while (msgs_int_blinded.to_s.length < msgs_int_blinded_len)
      msg_b = socket.gets().chomp.to_i
      msgs_int_blinded.append(msg_b)
    end
    # puts "msgs_int_blinded: #{msgs_int_blinded}"


    #Losuje j
    j = rand(100)
    puts"j: #{j}"

    #Wysyla do Alice
    socket.puts(j)

    #Odbiera data bez elementu [j]
    data_str_len = socket.gets().to_i
    # puts"data_str_len: #{data_str_len}"
    data = Array.new
    digest = socket.gets()
    data.append(digest)
    while (data.to_s.length < data_str_len)
      digest = socket.gets()
      data.append(digest)
    end
    # puts "data: #{data}"
    # puts"data_len: #{data.length()}"

    #Odbiera ks bez elementu [j]
    ks_str_len = socket.gets().to_i
    # puts"ks_str_len: #{ks_str_len}"
    ks = Array.new
    k = socket.gets().chomp.to_i
    ks.append(k)
    while (ks.to_s.length < ks_str_len)
      k = socket.gets().chomp.to_i
      ks.append(k)
    end
    # puts"ks: #{ks}"
    # puts"ks_len: #{ks.length()}"

    #yj
    msg_int_blinded = msgs_int_blinded[j]

    #Weryfikacja
    msgs_int_blinded.delete_at(j)
    # puts "msgs_int_blinded: #{msgs_int_blinded.length()}"
    for i in 0..data.length()-1
      #Oblicza H(Mi)
      d = data[i].to_s
      digest = OpenSSL::Digest::SHA1.digest(d)
      hash = text_to_int(digest)
      # puts"hash: #{hash}"

      #Odkrywa wiadomość h = y * k^-e mod n
      msg = unblind(msgs_int_blinded[i], ks[i], key)

      ver = (hash == msg)
      # puts "i: #{i}, ver: #{ver}"
      if ver == false
        puts "Nie przeszło weryfikacji yi, i=1..100 na kroku i: #{i}"
        break
      end
    end

    if (ver == true)
      puts "(Slepa wiad.) y: #{msg_int_blinded}"
      #Ślepo podpisuje sign()
      msg_int_blinded_signed = sign(msg_int_blinded, key)
      puts "(Podpisana sl. wiad.) z: #{msg_int_blinded_signed}"

      #Wysyła z
      socket.puts(msg_int_blinded_signed.to_s.length)
  		socket.puts(msg_int_blinded_signed)
    end

    break
end
rescue Errno::ECONNRESET, Errno::EPIPE => e
  putse.message
  retry
end
