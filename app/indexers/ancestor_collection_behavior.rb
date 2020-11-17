module AncestorCollectionBehavior
  extend ActiveSupport::Concern
  
  def ancestor_ids(record)
    return [] if record.nil?
    parents = record.member_of_collections
    parents += record.parent_works unless record.class == Collection
    ids = []
    parents.each do |parent|
      ids << parent.id
      ids += ancestor_ids(parent)
    end
    ids.uniq
  end

  def index_ancestor_titles(doc)
    doc['ancestor_collection_titles_ssim'] = ancestor_ids(object).map{|id| SolrDocument.find(id).title.first}
    doc 
  end
end
