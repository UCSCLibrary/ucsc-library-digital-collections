class Admin::BmiEdit < ApplicationRecord


  
  def get_csv(ids = nil)
    require 'csv'

    ids = work_ids if ids.nil? or ids.empty?
    
    csv=""
    metadata = []
    ids.each do |id|
      # go through every metadata element
      # add them to this item's metadata hash
      # add the item's hash to the global metadata array
    end
    meta_keys = get_metdata_keys(metadata)
    csv = CSV.generate do |csv|
      csv << get_file_header_line
      csv << meta_keys
      metadata.each do work_meta
        line = []
        meta_keys.each do |key|
          if work_meta[key].defined? and !work_meta[key].nil?
            line << work_meta[key]
          else
            line << ""
          end
        end
        csv << line
      end
    end
  end

  private

  def get_file_header_line
    #return the header for the whole file, 
    # with an appropriate name and such
  end

  def get_metadata_keys (metadata)
    metadata.reduce([]) |headers,item_meta| do
      headers | item_meta.keys
    end
  end

end
