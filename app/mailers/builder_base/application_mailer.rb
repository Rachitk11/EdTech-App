module BuilderBase
  class ApplicationMailer < ::ApplicationMailer
    default from: 'from@example.com'
    layout 'mailer'
  end
end
