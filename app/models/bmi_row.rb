class BmiRow < ApplicationRecord
  belongs_to :bmi_ingest

  def parse(headers)
    #parse self.text
    #make sure it matches up with headers array
    #update status
    #create log
    #return parsed array
  end

  def updateText(text)
    #TODO check if this is stupid (there is a convention for this)

    #log event
    #update text
  end

  def ingest(headers)
    #run parse self.text
    #make sure it matches up with headers array
    #start create_work job
    #update status
    #create log
  end

end
