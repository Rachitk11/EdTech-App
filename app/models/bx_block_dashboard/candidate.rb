module BxBlockDashboard
  class Candidate < BxBlockDashboard::ApplicationRecord
    def self.table_name_prefix
      'bx_block_dashboard_'
    #self.table_name = :bx_block_dashboard_candidates
  end

  def sub_attributres        
      [
        {
          type: "Interview with client",
          quantity: "100"
        },
        {
          type: "Submitted for feedback",
          quantity: "70"
        },
        {
          type: "Candidates expecting offer",
          quantity: "50"
        },
        {
          type: "Candidates accepted",
          quantity:"40"
      }
    ]
  end
end
end