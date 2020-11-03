module Ucsc
  class CollectionPresenter < Hyrax::CollectionPresenter
    def permission_badge_class
      Ucsc::PermissionBadge
    end

    def related_resource
      if solr_document.relatedResource.present?
        return solr_document.relatedResource
      end
    end

    def banner_url(size: "1300,", region: "0,200,1800,300")
      Hyrax.config.iiif_image_url_builder.call(self.representative_id,"nil",size,region)
    end
  end
end
