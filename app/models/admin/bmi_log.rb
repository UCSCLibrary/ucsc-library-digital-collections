class Admin::BmiLog < ApplicationRecord
  belongs_to :bmi_ingest
  belongs_to :bmi_row  
  belongs_to :bmi_cell
end
