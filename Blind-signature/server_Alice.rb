#Alice
#server
require 'socket'
require 'openssl'

def blinding_factor(key)
  n = key.n.to_i
  k = rand(n-1).to_i
  k += 1 while k.gcd(n) !=1
  return k
end

def text_to_int(text)
  bitmap = '1' + text.unpack('B*')[0]
	bitmap.to_i(2)
end

def blind(msg, key)
  k = blinding_factor(key)
  # puts "k: #{k}"
  msg_int = text_to_int(msg)
  # puts "msg_int: #{msg_int}"

  # y = h*k^e (mod n)
	msg_int_blinded = msg_int * k.to_bn.mod_exp(key.e, key.n) % key.n
  # puts "msg_int_blinded: #{msg_int_blinded}"
  return msg_int_blinded, k
end

def unblind(blinded_msg, k, key)
  # s = z*k^-1 (mod n)
	msg = blinded_msg * k.to_bn.mod_inverse(key.n) % key.n
  return msg
end

def verify(msg_signed, msg, key)
	# M == h = s^e(mod n)
  # puts "signed_text: #{int_to_text(h)}"
	h = msg_signed.to_bn.mod_exp(key.e, key.n) % key.n
	ver = h == msg
	return ver
end


file = "test.txt"
server = TCPServer.open(4567)
begin
  while client = server.accept
    #Odbiera Klucz
    key_len = client.gets().to_i
    key = client.gets()
    while (key.to_s.length < key_len)
      key += client.gets()
    end
    key = key.chomp
    key =  OpenSSL::PKey::RSA.new(key)
    # puts"public key: #{key}"


    #Przygotowuje Mi, i = 1 .. 100
    msgs = Array.new
    f = File.open(file, "r+")
    f.each_line { |line|
      msgs.append(line)
    }
    # puts "msg: #{msgs}\nmsg_len: #{msgs.length()}"


    #Losuje ki, oblicza i zakrywa hi = H(M), i = 1..100
    data = Array.new
    msgs_int_blinded = Array.new
    ks = Array.new
    msgs.each { |msg|
      #Oblicz h = H(M)
      digest = OpenSSL::Digest::SHA1.digest(msg)
      data.append(digest)

      #Zakrywa h, y = h*k^e(mod n)
      msg_int_blinded, k = blind(digest, key)
      msgs_int_blinded.append(msg_int_blinded)
      ks.append(k)
    }
    # puts"data: #{data}\ndata_len: #{data.length}"
    # puts"msgs_int_blinded: #{msgs_int_blinded}\nmsgs_int_blinded_len: #{msgs_int_blinded.length()}"
    # puts"ks: #{ks}\nks_len: #{ks.length}"


    #Wysyła wszystkie zakryte hash yi, i= 1..100
    client.puts(msgs_int_blinded.to_s.length)
    # puts"length_str_msgs_int_blinded: #{msgs_int_blinded.to_s.length}"
    client.puts(msgs_int_blinded)
    # puts "msgs_int_blinded: #{msgs_int_blinded}"


    #Pobiera j od Boba
    j = client.gets().chomp.to_i
    puts"j: #{j}"

    #Zapisuje j-element
    digest = OpenSSL::Digest::SHA1.digest(msgs[j])
    k = ks[j]

    #Usuwa j-element z Mi, ki
    msgs.delete_at(j)
    # puts"data_len: #{data.length}"
    ks.delete_at(j)
    # puts"ks_len: #{ks.length}"

    #Wysyła  data i ks bez elementu [j]
    client.puts(msgs.to_s.length)
    # puts"data_str_len: #{data.to_s.length}"
    client.puts(msgs)

    client.puts(ks.to_s.length)
    # puts"ks_str_len: #{ks.to_s.length}"
    client.puts(ks)
    # puts "ks: #{ks}"


    # puts "msgs_int_blinded[j]: #{msgs_int_blinded[j]}"
    #Odbiera z (slepa_podpisana wiadomosc)
    msg_int_blinded_signed_len = client.gets().to_i
    # puts "msg_int_blinded_signed_len: #{msg_int_blinded_signed_len}"
    msg_int_blinded_signed = client.gets()
    while (msg_int_blinded_signed.to_s.length < msg_int_blinded_signed_len)
      msg_int_blinded_signed += client.gets()
    end
    msg_int_blinded_signed = msg_int_blinded_signed.chomp.to_i.to_bn
    puts "z: #{msg_int_blinded_signed}"

    #Odkrywa podpis
    msg_int_signed = unblind(msg_int_blinded_signed, k, key)
    puts "(Podpisana wiadomość po odkryciu) s: #{msg_int_signed}"

    msg_int = text_to_int(digest)
    # puts "msg_int: #{msg_int}"

    ver = verify(msg_int_signed, msg_int, key)
    puts "weryfikacja: #{ver}"

    client.close
    break
end
rescue Errno::ECONNRESET, Errno::EPIPE => e
  putse.message
  retry
end
