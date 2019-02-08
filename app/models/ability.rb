require 'bulk_ops/operation'

class Ability
  include Hydra::Ability
  include Hyrax::Ability
  
  self.ability_logic += [:everyone_can_create_curation_concerns]

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
