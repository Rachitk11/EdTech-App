module AccountBlock
  module Accounts
    class CountryCodeAndFlagsController < ApplicationController
      def show
        render json: CountryCodeAndFlagSerializer
          .new(Country.all.sort_by { |c| c.name })
          .serializable_hash
      end
    end
  end
end
