module BxBlockSms
  class SendSms
    attr_reader :to, :text_content

    def initialize(to, text_content)
      @to = to
      @text_content = text_content
    end

    def call
      Provider.send_sms(to, text_content)
    end
  end
end
