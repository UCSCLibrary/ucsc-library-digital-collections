module Ucsc
  module Workflow
    class Claim < ApplicationRecord
      belongs_to :user

      self.table_name = 'sipity_claim'

    end
  end
end
