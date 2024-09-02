module BxBlockContentManagement
  class BaseError < StandardError; end
  class InvalidSheetHeaders < BaseError; end

  module Base
    extend BxBlockContentManagement::Interface

    need_to_implement :import_data, :get_headers

    def call(xlsx, sheet_name, error_tracker)
      return unless xlsx.sheets.include?(sheet_name)
      sheet = xlsx.sheet(sheet_name)
      @sheet_headers = sheet.first
      @sheet_content = []
      @sheet_name = sheet_name
      @error_tracker = error_tracker

      begin
        validate_headers!
        process_sheet_content(sheet)
        import_data
      rescue BaseError => e
        add_errors_to_tracker(e.message)
      end
    end

    def add_errors(msg, name, sn, object_name, identifier)
      @error_tracker.add_errors(
        "In #{@sheet_name}: Their was error occurred in saving #{object_name} with #{identifier} " \
        "'#{name}' in row with sn: '#{sn}', errors: #{msg}"
      )
    end

    def add_errors_to_tracker(msg)
      @error_tracker.add_errors(msg)
    end

    def strip(str)
      str.to_s.strip
    end

    def strip_downcase(str)
      strip(str).downcase
    end

    def validate_headers!
      unless verify_headers?
        raise InvalidSheetHeaders.new(get_missing_header_message)
      end
    end

    def process_sheet_content(sheet)
      sheet.each(get_headers) do |row|
        @sheet_content << row
      end
      @sheet_content.shift
    end

    def verify_headers?
      missing_headers.blank?
    end

    def missing_headers
      get_headers.values - @sheet_headers
    end

    def build_attributes(row, trnsf_keys = transform_keys)
      attributes = {}
      get_headers.each do |k,_|
        value = row[k]
        key = trnsf_keys[k] || k
        if value.is_a?(String)
         attributes[key] = strip(value)
        else
         attributes[key] = value
        end
      end
      attributes
    end

    def transform_keys
      {}
    end

    def get_missing_header_message
      missing_sheet_headers = missing_headers.to_sentence
      "Missing headers in sheet #{@sheet_name}: #{missing_sheet_headers}"
    end
  end
end
