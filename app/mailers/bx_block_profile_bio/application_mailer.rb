# frozen_string_literal: true

module BxBlockProfileBio
  class ApplicationMailer < BuilderBase::ApplicationMailer
    default from: 'from@example.com'
    layout 'mailer'
  end
end
