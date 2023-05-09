module Ucsc
  class CollectionPresenter < Hyrax::CollectionPresenter

    delegate :collectionCallNumber, :extent, :donorProvenance, :publisher, :publisherHomepage, :rightsStatement, :rightsHolder, :rightsStatus, :accessRights,:subjectName, :subjectPlace, :subjectTopic, :subjectTitle, :dateCreated, :dateCreatedDisplay, :harmfulLanguageStatement, to: :solr_document

    def permission_badge_class
      Ucsc::PermissionBadge
    end

    def metadataSource
      if solr_document.metadataSource.present?
        return solr_document.metadataSource
      end
      []
    end      
    
    def related_resource
      if solr_document.relatedResource.present?
        return solr_document.relatedResource
      end
    end

    def banner_url(size: "1300,", region: "0,1100,1800,300")
      return "" unless (builder_id = solr_document.representative_id || solr_document.thumbnail_id)
      Hyrax.config.iiif_image_url_builder.call(builder_id,"nil",size,region)
    end

    # Override to be able to pass parameters from A-Z page
    def total_viewable_items(id, current_ability)
      ActiveFedora::Base.where("member_of_collection_ids_ssim:#{id}").accessible_by(current_ability).count
    end
  end
end
