module Ucsc
  class CollectionPresenter < Hyrax::CollectionPresenter
    def permission_badge_class
      Ucsc::PermissionBadge
    end
  end
end
