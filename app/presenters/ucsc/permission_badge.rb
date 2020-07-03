module Ucsc
  class PermissionBadge < Hyrax::PermissionBadge

    UCSC_VISIBILITY_LABEL_CLASS = {
      authenticated: "label-info",
      embargo: "label-warning",
      lease: "label-warning",
      request: "label-warning",
      campus: "label-warning",
      open: "label-success",
      restricted: "label-danger"
    }.freeze
    
    def dom_label_class
      UCSC_VISIBILITY_LABEL_CLASS.fetch(@visibility.to_sym)
    end
  end
end
