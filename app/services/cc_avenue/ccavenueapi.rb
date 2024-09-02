require 'uri'
require 'net/http'
require 'openssl'


# CcAvenue::Ccavenue_Api.new.orderStatusTracker(post_data=nil)
module CcAvenue
  class Ccavenueapi
    # Provide working key share by CCAvenues
    attr_accessor :working_key

    # Provide access code Shared by CCAVENUES
    attr_accessor :access_code

    # Version Number
    attr_accessor :version

    def initialize(working_key=BxBlockGlobalSetting::GlobalSetting.last.ccavenue_api_working_key, access_code=BxBlockGlobalSetting::GlobalSetting.last.ccavenue_api_access_code, version='1.2')
      @working_key = working_key
      @access_code = access_code
      @version = version
      @url = URI(BxBlockGlobalSetting::GlobalSetting.last.api_url)
      # @url = URI("https://apitest.ccavenue.com/apis/servlet/DoWebTrans")
    end

    def api_call(final_data)
      http = Net::HTTP.new(@url.host, @url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Post.new(@url)
      request.content_type = 'application/x-www-form-urlencoded'
      request.body = final_data
      response = http.request(request)
      @json_data = {}
      response.read_body.split("&").each do |str|
        str_array = str.split("=")
        @json_data[str_array[0]] = str_array[1] 
      end
      if (@json_data["status"] == "0") || (@json_data["status"] == 0)
        descrpt_response = CcAvenue::Ccavenue.new.decrypt(@json_data["enc_response"].strip, BxBlockGlobalSetting::GlobalSetting.last.ccavenue_api_working_key)
      else
        descrpt_response = @json_data
      end
      return descrpt_response
      # information = response.body.split('&')
      # dataSize = information.length
      # status1 = information[0].split('=') rescue nil
      # status2 = information[1].split('=') rescue nil
      # status3 = information[2].split('=') rescue nil

      # if status1[1] == '1'
      #   return "#{status2[1]} Error Code: #{status3[1]}"
      # else
      #   status = self.decrypt(status2[1], @working_key)
      #   return status
      # end
    end

    def orderStatusTracker(post_data=nil)
      merchant_data = post_data.to_json
      # Encrypt merchant data with working key shared by ccavenue
      encrypted_data = self.encrypt(merchant_data, @working_key)

      # make final request string for the API call
      command = "orderStatusTracker"
      final_data = "request_type=JSON&access_code=#{@access_code}&command=#{command}&response_type=JSON&version=#{@version}&enc_request=#{encrypted_data}"
      result = self.api_call(final_data)

      return result
    end

    def encrypt(plain_text, key)
      secret_key = hextobin(Digest::MD5.hexdigest(key))
      init_vector = [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f].pack('C*')
      cipher = OpenSSL::Cipher::AES.new(128, :CBC)
      cipher.encrypt
      cipher.padding = 0
      cipher.key = secret_key
      cipher.iv = init_vector
      encrypted_text = cipher.update(pkcs5_pad(plain_text, 16))
      encrypted_text << cipher.final
      return encrypted_text.unpack('H*')[0]
    end

    # def decrypt(encrypted_text, key)
    #   secret_key = hextobin(Digest::MD5.hexdigest(key))
    #   init_vector = [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f].pack('C*')
    #   cipher = OpenSSL::Cipher::AES.new(128, :CBC)
    #   cipher.decrypt
    #   cipher.padding = 0
    #   cipher.key = secret_key
    #   cipher.iv = init_vector
    #   decrypted_text = cipher.update([encrypted_text].pack('H*'))
    #   decrypted_text << cipher.final
    #   return pkcs5_unpad(decrypted_text)
    # end

    # def cancel_order(post_data)
    #   merchant_data = post_data.to_json

    #   # Encrypt merchant data with working key shared by ccavenue
    #   encrypted_data = encrypt(merchant_data, @working_key)

    #   # Make final request string for the API call
    #   command = 'cancelOrder'
    #   final_data = "request_type=JSON&access_code=#{@access_code}&command=#{command}&response_type=JSON&version=#{@version}&enc_request=#{encrypted_data}"
    #   result = api_call(final_data)

    #   return result
    # end


    def hextobin(hex_string)
      length = hex_string.length
      bin_string = ""
      count = 0
      
      while count < length
        sub_string = hex_string[count, 2]
        packed_string = [sub_string].pack("H*")
        
        if count == 0
          bin_string = packed_string
        else
          bin_string += packed_string
        end
        
        count += 2
      end
      
      return bin_string
    end

    def pkcs5_pad(plain_text, block_size)
      pad = block_size - (plain_text.length % block_size)
      plain_text + pad.chr * pad
    end

    # def getPendingOrders(post_data)
    #   # function for get pending orders
    #   merchant_data = post_data.to_json

    #   # Encrypt merchant data with working key shared by ccavenue
    #   encrypted_data = self.encrypt(merchant_data, @working_key)

    #   # make final request string for the API call
    #   command = "getPendingOrders"
    #   final_data = "request_type=JSON&access_code=#{@access_code}&command=#{command}&response_type=JSON&version=#{@version}&enc_request=#{encrypted_data}"
    #   result = self.api_call(final_data)

    #   return result
    # end

    # def confirmOrder(post_data)
    #   # function for confimorder
    #   merchant_data = post_data.to_json

    #   # Encrypt merchant data with working key shared by ccavenue
    #   encrypted_data = self.encrypt(merchant_data, @working_key)

    #   # make final request string for the API call
    #   command = "confirmOrder"
    #   final_data = "request_type=JSON&access_code=#{@access_code}&command=#{command}&response_type=JSON&version=#{@version}&enc_request=#{encrypted_data}"
    #   result = self.api_call(final_data)

    #   return result
    # end

    def refund_order(post_data, params)
      merchant_data = post_data.to_json
      encrypted_data = encrypt(merchant_data, @working_key)
      command = params["command"] || params[:command]
      api_version = params["version"] || params[:version]
      final_data = "request_type=JSON&access_code=#{@access_code}&command=#{command}&response_type=JSON&version=#{api_version}&enc_request=#{encrypted_data}"
      result = api_call(final_data)
      return result
    end
  end
end 
