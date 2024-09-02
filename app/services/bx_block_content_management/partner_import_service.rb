# BxBlockContentManagement::CategoryImportService.call(xlsx, error_tracker)

module BxBlockContentManagement
  class PartnerImportService
    extend Base

    class << self

      def call(xlsx, error_tracker)
        super(xlsx, 'partner_sheet', error_tracker)
      end

      def import_data

        @sheet_content.each do |sheet_content|

          build_value = build_attributes(sheet_content)
          category_arr = []
          build_value[:categories_name].split(", ").each do |category_name|
            category = BxBlockCategories::Category.find_by('lower(name) = ?', strip_downcase(category_name))
            unless category.present?
              add_errors(
                "can't find category with this name",
                sheet_content[:name], sheet_content[:sn], 'partner', 'name'
              )
            else
              category_arr << category.id
            end
          end

          sub_category_arr = []

          build_value[:sub_categories_name].split(", ").each do |sub_category_name|
            sub_category = BxBlockCategories::SubCategory.find_by(
              'lower(name) = ?', strip_downcase(sub_category_name)
            )
            unless sub_category.present?
              add_errors(
                "can't find sub category with this name",
                sheet_content[:name], sheet_content[:sn], 'partner', 'name'
              )
            else
              sub_category_arr << sub_category.id
            end
          end

          content_type_arr = []

          build_value[:content_types_name].split(", ").each do |content_type_name|
            content_type = BxBlockContentManagement::ContentType.find_by(
              'lower(name) = ?', strip_downcase(content_type_name)
            )
            unless content_type.present?
              add_errors(
                "can't find content type with this name",
                sheet_content[:name], sheet_content[:sn], 'partner', 'name'
              )
            else
              content_type_arr << content_type.id
            end
          end
        end
      end

      def get_headers
        {
          sn: 'sn',
          email: 'email',
          name: 'name',
          spoc_name: 'spoc_name',
          address: 'address',
          categories_name: 'categories_name',
          sub_categories_name: 'sub_categories_name',
          content_types_name: 'content_types_name',
          spoc_contact: 'spoc_contact',
          status: 'status',
          partner_type: 'partner_type',
          partnership_type: 'partnership_type',
          partner_margins_per: 'partner_margins_per',
          tax_margins: 'tax_margins',
          bank_ifsc: 'bank_ifsc',
          account_number: 'account_number',
          account_name: 'account_name',
          bank_name: 'bank_name'
        }
      end

      private

      def create_admin_attributes(name, email, spoc_name, role, address, spoc_contact, status,
                                  partner_type, partnership_type, partner_margins_per, tax_margins,
                                  bank_ifsc, account_number, account_name, bank_name, category_ids,
                                  sub_category_ids, content_type_ids)
        {
          email: email,
          role: role,
          partner_attributes:{
            name: name,
            address: address,
            spoc_name: spoc_name,
            spoc_contact: spoc_contact,
            category_ids: category_ids,
            sub_category_ids: sub_category_ids,
            content_type_ids: content_type_ids,
            status: status,
            partner_type: partner_type,
            partnership_type: partnership_type,
            partner_margins_per: partner_margins_per,
            tax_margins: tax_margins,
            bank_ifsc: bank_ifsc,
            account_number: account_number,
            account_name: account_name,
            bank_name: bank_name
          }
        }
      end

    end
  end
end
