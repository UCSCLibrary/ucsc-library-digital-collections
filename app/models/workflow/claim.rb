module Workflow
  class Claim < ApplicationRecord
    belongs_to :user
    belongs_to :sipity_workflow_states

    self.table_name = 'sipity_claims'


    alias resolve! destroy!

  end
end
