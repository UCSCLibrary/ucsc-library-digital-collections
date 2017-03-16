module Ucsc
  module BatchEditsControllerBehavior


    def getClass(batch)
      batch_class = false;
      batch.each() do |work_id|
        work_class = ActiveFedora::Base.search_by_id(work_id)["has_model_ssim"].first.constantize
        if work_class == batch_class
          next
	end
	if !batch_class
          batch_class = work_class;
        else
          raise 'Batch editing of multiple work types is not supported'
        end
      end
      return batch_class
    end

    def edit
      super
      work = getClass(batch).new
      work.depositor = current_user.user_key
      @form = form_class.new(work, current_user, batch)
    end

    protected

      def form_class
        Ucsc::Forms::BatchEditForm
      end

  end
end
