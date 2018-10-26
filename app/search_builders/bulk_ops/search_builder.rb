class BulkOps::SearchBuilder < ::SearchBuilder

  attr_reader :collection, :admin_set, :workflow_state
  class_attribute :collection_membership_field, :admin_set_field, :workflow_state_field
  self.collection_membership_field = 'member_of_collection_ids_ssim'
  self.admin_set_field = 'admin_set_tesim'
  self.workflow_state_field = 'workflow_state_name_ssim'

  self.default_processor_chain += [:member_of_collection, :member_of_admin_set, :in_workflow_state]
  
  # @param [scope] Typically the controller object
  def initialize(scope: {}, collection: nil, admin_set: nil, keyword_query: nil, workflow_state: nil) 
    @collection = collection
    @admin_set = admin_set
    @workflow_state = workflow_state
    @keyword_query = keyword_query
    super(scope)
  end
  
  # include filters into the query to only include the collection memebers
  def member_of_collection(solr_parameters)
    solr_parameters[:fq] ||= []
    solr_parameters[:fq] << "#{collection_membership_field}:#{@collection.id}" if @collection
  end

  # include filters into the query to only include the collection memebers
  def member_of_admin_set(solr_parameters)
    solr_parameters[:fq] ||= []
    solr_parameters[:fq] << "#{admin_set_field}:#{@admin_set.name}" if @admin_set
  end

  # include filters into the query to only include the collection memebers
  def in_workflow_state(solr_parameters)
    solr_parameters[:fq] ||= []
    solr_parameters[:fq] << "#{workflow_state_field}:#{@workflow_state.name}" if @workflow_state
  end

  def with_keyword_query
    solr_parameters[:q] ||= []
    solr_parameters[:q] << @keyword_query if @keyword_query
  end

end
