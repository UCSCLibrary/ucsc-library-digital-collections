module HyraxHelper
  include ::BlacklightHelper
  include Hyrax::BlacklightOverride
  include Hyrax::HyraxHelperBehavior

  def visibility_badge(value)
    Ucsc::PermissionBadge.new(value).render
  end
end
