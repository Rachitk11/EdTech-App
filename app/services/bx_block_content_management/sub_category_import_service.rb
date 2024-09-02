# BxBlockContentManagement::CategoryImportService.call(xlsx, error_tracker)

module BxBlockContentManagement
  class SubCategoryImportService
    extend Base

    class << self

      def call(xlsx, error_tracker)
        super(xlsx, 'sub_category_sheet', error_tracker)
      end

      def import_data

        @sheet_content.each do |sheet_content|
          category_new = nil
          parent = nil
          # Find or Create category
          if sheet_content[:parent_name].present?
            parent = BxBlockCategories::SubCategory.find_by(
              'lower(name) = ?', strip_downcase(sheet_content[:parent_name])
            )
            add_errors(
              "can't find parent with name '#{sheet_content[:parent_name]}'",
              sheet_content[:name], sheet_content[:sn], 'sub category', 'name'
            ) unless parent.present?
          end
          if sheet_content[:category_name].present?
            category_new = find_category(sheet_content[:category_name])
            unless category_new.present?
              add_errors(
                "can't find category with name '#{sheet_content[:parent_name]}'",
                sheet_content[:name], sheet_content[:sn], 'sub category', 'name'
              )
            else
              sub_category = create_sub_category(sheet_content[:name], category_new, parent)
              if sub_category.errors.present?
                add_errors(
                  sub_category.errors.full_messages.to_sentence,
                  sheet_content[:name], sheet_content[:sn], 'sub category', 'name'
                )
              end
            end
          else
            sub_category = create_sub_category(sheet_content[:name], category_new, parent)
            if sub_category.errors.present?
              add_errors(
                sub_category.errors.full_messages.to_sentence,
                sheet_content[:name], sheet_content[:sn], 'sub category', 'name'
              )
            end
          end
        end
      end

      def get_headers
        {
          sn: 'sn',
          name: 'name',
          category_name: 'category_name',
          parent_name: 'parent_name',
          rank: 'rank'
        }
      end

      private

      def find_category(c_name)
        BxBlockCategories::Category.find_by('lower(name) = ?', strip_downcase(c_name))
      end

      def create_sub_category(sc_name, category=nil, parent=nil)
        sub_category_exist = BxBlockCategories::SubCategory.find_by('lower(name) = ?', strip_downcase(sc_name))
        if sub_category_exist.blank?
          sub_category_exist =  BxBlockCategories::SubCategory.new()
        end
        sub_category_exist.update(sub_category_params(sc_name, parent, category))
        sub_category_exist
      end

      def sub_category_params(sc_name, parent, category=nil)

        params = {
          name: sc_name,
          parent_id: parent&.id
        }
        params.merge!(categories: [category]) if category.present?
        params
      end

    end
  end
end
