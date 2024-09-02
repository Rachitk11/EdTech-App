module BxBlockPosts
  class Post < BxBlockPosts::ApplicationRecord
    self.table_name = :posts
    ActiveSupport.run_load_hooks(:post, self)

    if ENV['TEMPLATEAPP_DATABASE']
      include PublicActivity::Model
      tracked owner: proc { |controller, _| controller&.current_user }
    end
    IMAGE_CONTENT_TYPES = %w(image/jpg image/jpeg image/png)

    has_many_attached :images, dependent: :destroy

    belongs_to :category,
               class_name: 'BxBlockCategories::Category'

    belongs_to :sub_category,
               class_name: 'BxBlockCategories::SubCategory',
               foreign_key: :sub_category_id, optional: true

    belongs_to :account, class_name: 'AccountBlock::Account'
    has_many_attached :media, dependent: :destroy

    validates_presence_of :body
    validates :media,
    size: { between: 1..3.megabytes }, content_type: IMAGE_CONTENT_TYPES

  end
end
