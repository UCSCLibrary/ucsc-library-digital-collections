module Ucsc
  class WorkMemberPresenterFactory < Hyrax::MemberPresenterFactory
    
    self.work_presenter_class = WorkShowPresenter

    delegate :grandchild_file_set_ids, to: :@work

    def file_set_presenters
      @file_set_presenters ||= member_presenters(((ordered_ids & file_set_ids) + grandchild_file_set_ids).uniq.reverse)
    end

    def ordered_ids
      super.reverse
    end

  end
end
