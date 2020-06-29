module AncestorCollectionBehavior
  extend ActiveSupport::Concern
  
  def ancestor_ids(record)
    return [] if record.nil? 
    ids = [record.id]
    ids += record.member_of_collection_ids
    record.parent_works.each { |parent| ids += ancestor_ids(parent) }
    return (ids.uniq - [record.id])
  end
end
