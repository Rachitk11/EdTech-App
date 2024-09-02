module BxBlockSplitpayments
  class Order < BxBlockSplitpayments::ApplicationRecord
    include Wisper::Publisher
    self.table_name = :bx_block_splitpayments_orders

    def self.complete_order(order_detail)
      @transaction = BxBlockPayments::Transaction.where(order_id: order_detail.id).last
      @order = BxBlockShoppingCart::Order.find_by(id: order_detail.id)
      bank_amount_details = []
      amount = []
      @order.poc_services.where.not(completed_at: nil).each do |poc_service|
        @account = AccountBlock::Account.find_by(id: poc_service.poc_id)
        @sub_account_id = @account&.bank_accounts&.last&.ccavenue_bank_account_id
        split_amount = poc_service.earning
        if @account.present? && @sub_account_id.present?
          bank_amount_details << {:splitAmount=>split_amount.to_f.round(2), :subAccId=>@sub_account_id}
          amount << split_amount.to_f.round(2)
        else
          bank_amount_details = []
        end
      end
      if bank_amount_details.blank?
        @order.update_column(:split_detail, "Bank Account Details should be present.")
      elsif @transaction.present? && ((@transaction.ccavenue_status == "Success") || (@transaction.ccavenue_status == "success")) && amount.any? && (Time.now > (@transaction.created_at + 45.minutes))
        mer_comm = @order.total_final_amt - amount.sum.to_f.round(2)
        params_data = {"command": "createSplitPayout", "version": 1.2}
        @data = {"split_tdr_charge_type"=>"A", "reference_no"=>@transaction.ccavenue_payment_id, "merComm"=>mer_comm, "split_data_list"=>bank_amount_details}
        @order.update_column(:split_account_detail, @data.to_json)
        response = CcAvenue::Ccavenueapi.new.refund_order(@data, params_data)
        BxBlockSplitpayments::Order.split_response(@order, response, @transaction)
      else
        @order.update_column(:split_detail, "there is some error in split payment")
      end
    end

    def self.split_response(order, response, transaction)
      json_response =  JSON.parse(response)["Create_Split_Payout_Result"] rescue {}
      if json_response["status"] == 0
        order_is_split = true
        transaction_is_split = true
      else
        order_is_split = false
        transaction_is_split = false
      end
      order.update_column(:split_detail, json_response.to_json)
      order.update_column(:is_split, order_is_split)
      transaction.update(is_split: transaction_is_split, split_detail: json_response.to_json)
    end
  end
end