module Ucsc
  class PermissionBadge < Hyrax::PermissionBadge

    def dom_label_class
      UCSC_VISIBILITY_LABEL_CLASS.fetch(@visibility.to_sym)
    end


    UCSC_VISIBILITY_LABEL_CLASS = {
      authenticated: "label-info",
      embargo: "label-warning",
      lease: "label-warning",
      request: "label-warning",
      open: "label-success",
      restricted: "label-danger"
    }.freeze
  end
end
