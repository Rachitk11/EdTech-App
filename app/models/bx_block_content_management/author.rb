module BxBlockContentManagement
  class Author < ApplicationRecord
    self.table_name = :authors
    has_many :contents, class_name: "BxBlockContentManagement::Content", dependent: :destroy
    validates :name, :bio, presence: true
    validates :bio, :length => {
      :maximum   => 500, :too_long  => "should not greater then %{count} words"
    }
    has_one :image, as: :attached_item, dependent: :destroy

    accepts_nested_attributes_for :image, allow_destroy: true
  end
end
