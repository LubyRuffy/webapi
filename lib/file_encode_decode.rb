class FileEncodeDecode
  require 'openssl'
  require 'digest'

  def initialize(alg, pass, salt)
    @alg = alg
    @pass = pass
    @salt = salt
  end

  def encrypt_by_password(text) #alg, pass, salt,
    # puts "--Encrypting--"
    begin
      enc = OpenSSL::Cipher.new(@alg)
      enc.encrypt
      enc.pkcs5_keyivgen(@pass, @salt)
      cipher =  enc.update(text)
      cipher << enc.final
    rescue => e
      raise e
    end

    # puts %(encrypted text: #{cipher.inspect})

    cipher
  end

  def decrypt_by_password( text)
    #puts "--Decrypting--"
    begin
      dec = OpenSSL::Cipher.new(@alg)
      dec.decrypt
      dec.pkcs5_keyivgen(@pass, @salt)
      plain =  dec.update(text)
      plain << dec.final
    rescue => e
      puts e
    end
    # puts %(decrypted text: "#{plain}")
    # puts
    plain.to_s
  end

  #alg  = 'AES-256-CBC'
  # alg = 'DES-CBC'
  # pass = "secret password"
  # salt = "8 octets"        # or nil

  #d = ecrypt_by_password(alg, pass, salt, text)

  def pack_file() #alg, pass,salt
    content = File.read('/tmp/checks.tar.gz')

    checksum = Digest::MD5.hexdigest(content)
    en_content = encrypt_by_password(content)

    begin
      fp = File.open('/tmp/package.bin', 'w+')
      fp.write checksum
      fp.write(en_content.force_encoding("UTF-8"))
    rescue => e
      raise e
    ensure
      fp.close
    end
  end

  def unpack_file(tar_file) #alg, pass, salt

    begin
      fp = File.open('/tmp/package.bin', 'r+')

      checksum_read = fp.sysread(32)
      content = fp.read
    rescue => e
      puts(e)
      fp.close if fp
      return false
    end

    de_content = decrypt_by_password( content)

    checksum_calc = Digest::MD5.hexdigest(de_content)

    puts "read checksum #{checksum_read}, calc #{checksum_calc}"
    #puts '====checksum not matched====' unless checksum_calc == checksum_read

    if checksum_calc != checksum_read
      puts '====checksum not matched===='
      return false
    end

    begin
      fp = File.open(tar_file, 'w+')
      fp.write(de_content.force_encoding("UTF-8"))
    rescue => e
      puts e
      fp.close if fp
      return false
    end

    true
  end

end
