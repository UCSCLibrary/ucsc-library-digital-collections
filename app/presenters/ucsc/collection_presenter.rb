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

  end
end
