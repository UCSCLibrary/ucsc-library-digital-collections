require 'bulk_ops/operation'
require 'ipaddr'

class Ability
  include Hydra::Ability
  include Hyrax::Ability

  def initialize user, client_ip=nil
    @client_ip = client_ip
    super user
  end
  
  CAMPUS_IP_RANGES = ["128.114.0.0/16"]
  
  self.ability_logic += [:everyone_can_create_curation_concerns]

  def test_read(id)
    return true if current_user.admin?
    # perform special checks on filesets
    if (fs = SolrDocument.find(id)).hydra_model == FileSet
      case fs.visibility
      when "open"
        return true
      when "request"
        # retrieve special access grants for the current user
        return (fs.ancestor_ids & current_user.current_access_grants).present?
      when "campus"
        return on_campus?
      end
    end
    super
  end

  def on_campus?
    CAMPUS_IP_RANGES.any?{|range| IPAddr.new(range).include?(@client_ip || "")}
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

    # Limits deleting objects to admin users
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
