module BxBlockSettings
  class SettingSerializer < BuilderBase::BaseSerializer
    attributes *[
        :name,
        :title
    ]
  end
end
