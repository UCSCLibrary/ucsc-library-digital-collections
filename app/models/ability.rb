require 'bulk_ops/operation'

class Ability
  include Hydra::Ability
  include Hyrax::Ability
  
  self.ability_logic += [:everyone_can_create_curation_concerns]



  def test_read(id)
    # retrieve special access grants for the current user
    grants = current_user.current_access_grants
    # grant access if this user is authorized for this record specifically
    return true if grants.include?(id)

    # perform special checks on filesets
    if (fs = SolrDocument.find(id))["has_model_ssim"].include? "FileSet"
      # retrieve the parent work and grant access if it the user has specific permission
      work = fs.parent_work
      return true if grants.include? work.id
      # check whether any of the fileset, work, or any collection the work belongs to has the visibility "request"
      if work.member_of_collection_ids.map{|col_id| SolrDocument.find(col_id).visibility}.push(work.visibility).push(fs.visibility).include?("request")
        # if so, grant access only if the user has specific privileges for that collection
        return work.member_of_collection_ids.any?{|id| grants.include?(id)}
      end
      # otherwise, allow access to the fileset if the work it belongs to is public
      return true if work.visibility == Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    end
 
    super
  end

  # Define any customized permissions here.
  def custom_permissions

    if current_user.admin?
      can [:create, :show, :add_user, :remove_user, :index, :edit, :update, :destroy], Role
      can :manage, BulkOps::Operation
      can :manage, User
    end

    if user_groups.include? "reviewer"
      can :read, ContentBlock
      can :read, :admin_dashboard
      
      can :review, :submissions

      can :view_admin_show_any, AdminSet
      can :view_admin_show_any, Collection
      can :view_admin_show_any, ::SolrDocument

      can [:show, :index, :edit, :update, :delete], BulkOps::Operation
    end

    # Limits deleting objects to a the admin user
    #
    # if current_user.admin?
    #   can [:destroy], ActiveFedora::Base
    # end

    # Limits creating new objects to a specific group
    #
    # if user_groups.include? 'special_group'
    #   can [:create], ActiveFedora::Base
    # end
  end
end
