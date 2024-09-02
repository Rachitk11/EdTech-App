#*****************************************************************
#     * COMPANY    - AVENUES INDIA PVT Ltd.,
#*****************************************************************

#Name of the Program : AES Encryption/Decryption
#Created by          : AVENUES INDIA PVT Ltd., TC-Team
#Created On          : 16-02-2014
#Version             : Version 1.0
#Contribution     : eLitmus Evaluation Pvt Ltd
#***************************************************************** 

module CcAvenue
  class Ccavenue# < ActiveRecord::Base

    INIT_VECTOR = (0..15).to_a.pack("C*")    
    
    def encrypt(plain_text, key)
        secret_key =  [Digest::MD5.hexdigest(key)].pack("H*") 
        cipher = OpenSSL::Cipher::Cipher.new('aes-128-cbc')
        cipher.encrypt
        cipher.key = secret_key
        cipher.iv  = INIT_VECTOR
        encrypted_text = cipher.update(plain_text) + cipher.final
        return (encrypted_text.unpack("H*")).first
    end

    def decrypt(cipher_text,key)
        secret_key =  [Digest::MD5.hexdigest(key)].pack("H*")
        encrypted_text = [cipher_text].pack("H*")
        decipher = OpenSSL::Cipher::Cipher.new('aes-128-cbc')
        decipher.decrypt
        decipher.key = secret_key
        decipher.iv  = INIT_VECTOR
        decrypted_text = (decipher.update(encrypted_text) + decipher.final).gsub(/\0+$/, '') rescue nil
        return decrypted_text
    end
  end
end

