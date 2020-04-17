module Ucsc
  class WorkShowPresenter < Hyrax::WorkShowPresenter
    include ScoobySnacks::PresenterBehavior

    delegate :file_set_ids, :image?, :audio?, to: :solr_document
    delegate :titleAlternative, :subseries, :series, to: :solr_document

    self.collection_presenter_class = Ucsc::CollectionPresenter

    def representative_presenter
      return nil unless representative_id
      file_set = SolrDocument.find(representative_id)
      return nil unless file_set
      Hyrax::FileSetPresenter.new(file_set,current_ability)
    end

    def universal_viewer?
      return true if (image? && (file_set_ids.count > 1))
      "click"
    end

    # We should delegate this to the solrDocument, which should have it already indexed (for works at least).
    def display_image_url(size="800,")
      if representative_id
        return "" unless current_ability.can?(:read, representative_id)
        representative_image = SolrDocument.find(representative_id)
        return "" unless representative_image.image?
        representative_image.display_image_url(size: size)
      elsif solr_document.image?
        solr_document.display_image_url(size: size)
      end
    end

    def zip_media_citation_url(size="1000,")
      "/works/#{id}/zip_media_citation/#{size}/media_citation.zip"
    end

    def all_av_files
      @all_av_files ||= generate_all_av_file_list
    end

    def parent
      return nil unless solr_document.parent_id.present?
      @parent ||= SolrDocument.find(solr_document.parent_id)
    end

    def parent_presenter
      return nil unless parent.present?
      @parent_presenter ||= Ucsc::WorkShowPresenter.new(parent, current_ability,request)
    end

    def page_title
      "#{solr_document.title.first} | UCSC Digital Library Collections"
    end

    def manifest_metadata *args
      super.reject{|md| md["value"].blank?}
    end
    
    def inherits?
      Array(solr_document.metadataInheritance).first.to_s.downcase.include?("display")
    end

    # If this is an audio work and its parent is also an audio work,
    # return its siblings. Otherwise, return its children.
    def all_av_files
      return @all_av_files if @all_av_files
      if parent.present? && parent.audio?
        @all_av_files = descendent_av_file_list(parent)
      else
        @all_av_files = descendent_av_file_list(solr_document)
      end
      unless @all_av_files.blank? or @all_av_files.find{|file| file[:playing]}
        @all_av_files[0][:playing] = true
      end
      return @all_av_files
    end

    def playing_now
      all_av_files.find{|file| file[:playing]}
    end

    private 

    # Return an array of filesets that belong to this work or its child works & descendent works
    def descendent_av_file_list(doc, root_parent=nil)
      av_filesets = doc.file_set_ids.map{|id| SolrDocument.find(id)}.select{|sd| sd.audio? || sd.video?}
      list = av_filesets.map.with_index(1) do |fs,i| 
        title = doc.title.first
        link = "/records/#{doc.id}"
        #link = "records/#{root_parent_id}##{fs.id}"
        if av_filesets.count > 1
          title = "#{title} - Track #{i}" 
          link = "#{link}##{fs.id}"
        end 
        # If the fileset title has been customized, then use that for the title
        title = fs.title.first unless fs.title.first =~ /^[\w,\s-]+\.[A-Za-z0-9]{3,4}$/
        {id: fs.id,
         title: title, 
         link: link,
         fileset: fs,
#         work: doc,
         playing: (id == doc.id) && (i == 1),
        }
      end
      doc.member_work_ids.map{|id| descendent_av_file_list(SolrDocument.find(id), root_parent)}.reduce(list,:+)
    end

    def member_presenter_factory
      WorkMemberPresenterFactory.new(solr_document, current_ability, request)
    end

    def find_renderer_class(name)
      return ::FacetedAttributeRenderer if name == :faceted
      super
    end



  end
end
