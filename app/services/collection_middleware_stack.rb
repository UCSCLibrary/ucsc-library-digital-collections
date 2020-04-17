class CollectionMiddlewareStack
  # rubocop:disable Metrics/MethodLength
  def self.build_stack
    ActionDispatch::MiddlewareStack.new.tap do |middleware|
      # Ensure you are mutating the most recent version
      middleware.use Hyrax::Actors::OptimisticLockValidator
#
#      # Add/remove the resource to/from a collection
#      middleware.use Hyrax::Actors::CollectionsMembershipActor
#
#      # Add/remove children (works or file_sets)
#      middleware.use Hyrax::Actors::AttachMembersActor
#
#      # Decode the private/public/institution on the form into permisisons on
#      # the model
      middleware.use Hyrax::Actors::InterpretVisibilityActor
#
#      # Handles transfering ownership of works from one user to another
      middleware.use Hyrax::Actors::TransferRequestActor
#
#      # Destroys the feature tag in the database when the work is destroyed
#      middleware.use Hyrax::Actors::FeaturedWorkActor
#
      # Persist the metadata changes on the resource
      middleware.use Hyrax::Actors::ModelActor

    end
  end
  # rubocop:enable Metrics/MethodLength
end
