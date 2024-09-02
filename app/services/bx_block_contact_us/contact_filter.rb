module BxBlockContactUs
  class ContactFilter
    DEFAULT_DATE_FORMAT = "%Y-%m-%d".freeze

    attr_accessor :active_record, :query_params, :date_format

    # Sample query_params:
    # {
    #   "account_id": 1,
    #   "name"=> {"comparator": "equals", "value": "test"},
    #   "email"=>{"comparator": "contains", "value": "demo"},
    #   "phone_nubmer"=>{"comparator": "starts_with", "value": "+91"},
    #   "description"=>{"comparator": "ends_with", "value": "test"},
    #   "created_at"=>{"comparator": "between", "from": "2020-09-01",
    #     "to": "2020-09-30"},
    #   "updated_at"=>{"comparator": "between", "from": "2020-09-01",
    #     "to": "2020-09-30"},
    # }
    def initialize(active_record, query_params,
                   date_format: DEFAULT_DATE_FORMAT)
      @active_record = active_record
      @query_params = query_params.permit!.to_h if query_params.present?
      @date_format = date_format
    end

    def call
      query_params.present? ?
          active_record.where(query_string) : active_record.all
    end

    private

    def query_string
      query_str = ""
      query_params.each_with_index do |(key, value), index|
        query_str += query_string_for(key, value)
        query_str += " AND " if index < query_params.length - 1
      end

      query_str
    end

    def query_string_for(attr_name, value_or_hash)
      return "#{attr_name} = #{value_or_hash}" if !value_or_hash.is_a?(Hash)

      value = value_or_hash[:value].to_s.downcase
      case value_or_hash[:comparator]
      when "equals"
        "LOWER(#{attr_name}) = '#{value}'"
      when "contains"
        "LOWER(#{attr_name}) LIKE '%#{value}%'"
      when "starts_with"
        "LOWER(#{attr_name}) LIKE '#{value}%'"
      when "ends_with"
        "LOWER(#{attr_name}) LIKE '%#{value}'"
      when "between"
        from = to_date(value_or_hash[:from])
        to = to_date(value_or_hash[:to])

        "DATE(#{attr_name}) >= '#{from}' AND DATE(#{attr_name}) <= '#{to}'"
      else
        ""
      end
    end

    def to_date(date_string)
      Date.strptime(date_string, date_format)
    end
  end
end
