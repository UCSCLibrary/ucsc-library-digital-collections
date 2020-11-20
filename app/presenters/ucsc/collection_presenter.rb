module Ucsc
  class CollectionPresenter < Hyrax::CollectionPresenter
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
  end
end
