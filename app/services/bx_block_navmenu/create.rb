module BxBlockNavmenu
  class Create
    def initialize(attributes)
      @attributes = attributes
    end

    def execute
      ActiveRecord::Base.transaction do
        @attributes.each do |position, items|
          navigation_menu =
              NavigationMenu.find_or_initialize_by(position: position)
          navigation_menu.items = items
          navigation_menu.save!
        end
      end
      NavigationMenu.all
    end
  end
end
