# BxBlockContentManagement::CategoryImportService.call(xlsx, error_tracker)

module BxBlockContentManagement
  class CategoryImportService
    extend Base

    class << self

      def call(xlsx, error_tracker)
        super(xlsx, 'category_sheet', error_tracker)
      end

      def import_data
        @sheet_content.each do |sheet_content|
          # Find or Create category
          category = BxBlockCategories::Category.where("lower(name) = ? ", strip_downcase(sheet_content[:name])).first
          if category.present?
            category.rank = sheet_content[:rank]
          else
            category = BxBlockCategories::Category.new(category_params(sheet_content[:name], sheet_content[:rank]))
          end

          category.save
          if category.errors.present?
            add_errors(
              category.errors.full_messages.to_sentence,
              sheet_content[:name], sheet_content[:sn], 'category', 'name'
            )
          end
        end
      end

      def get_headers
        {
          sn: 'sn',
          name: 'name',
          rank: 'rank'
        }
      end

      private

      def category_params(name, rank)
        {
          name: strip_downcase(name),
          rank: rank
        }
      end

    end
  end
end
