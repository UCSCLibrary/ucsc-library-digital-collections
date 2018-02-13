class CourseShowPresenter < Hyrax::WorkShowPresenter

  delegate :date_digitized,:physical_format,:digital_extent,:digital_publisher_homepage, to: :solr_document
  delegate :lecture_files, :ordered_work_ids, to: :member_presenter_factory

  private
  
  def member_presenter_factory
    CourseMemberPresenterFactory.new(solr_document, current_ability, request)
  end

end
