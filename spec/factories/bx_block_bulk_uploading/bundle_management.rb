FactoryBot.define do
  factory :bundle_management, class: 'BxBlockBulkUploading::BundleManagement' do
    title {FFaker::Book.title}
    description { "Description of bundle" }
    total_pricing { rand(5.0..50.0).round(2) }
    school_class_id {"7th A"}
    board {"UP Board"}
    cover_images { [Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'index.jpeg'), 'image/jpeg')] }

    trait :with_cover_images do
      cover_images { [Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'index.jpeg'), 'image/jpeg')] }
    end

    trait :without_cover_images do
      cover_images { nil }
    end
  end
end