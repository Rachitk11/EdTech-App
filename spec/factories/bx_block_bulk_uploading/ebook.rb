FactoryBot.define do
  factory :ebook, class: 'BxBlockBulkUploading::Ebook' do
    title {FFaker::Book.title}
    author {FFaker::Book.author}
    edition {"2018-19"}
    publisher {"Publisher Name"}
    publication_date {FFaker::Time.date}
    formats_available {"pdf"}
    language { FFaker::Locale.language }
    description { "This is book description" }
    price { rand(5.0..50.0).round(2) }
    school_id {"SVM"} 
    board {"UP Board"} 
    school_class_id {"7th A"}
    subject {"Math"}
    commission_percentage {"10%"}
    images { [Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'index.jpeg'), 'image/jpeg')] }

    trait :with_images do
      images { [Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'index.jpeg'), 'image/jpeg')] }
    end

    trait :without_images do
      images { nil }
    end

    pdf { Rack::Test::UploadedFile.new(Rails.root.join('spec/support/sample.pdf'), 'application/pdf') }

    trait :with_pdf do
      pdf { Rack::Test::UploadedFile.new(Rails.root.join('spec/support/sample.pdf'), 'application/pdf') }
    end

    trait :without_pdf do
      pdf { nil }
    end

    excel_file { Rack::Test::UploadedFile.new(Rails.root.join('spec/support/example1.xlsx'), 'text/xlsx') }

    trait :with_excel_file do
      excel_file { Rack::Test::UploadedFile.new(Rails.root.join('spec/support/example1.xlsx'), 'text/xlsx') }
    end
    trait :with_non_excel_file do
      excel_file { Rack::Test::UploadedFile.new(Rails.root.join('spec/support/index.jpeg'), 'photo/jpeg') }
    end
  end
end