class SipityClaim < ApplicationRecord
  belongs_to :user

  self.table_name = 'sipity_claim'

end
