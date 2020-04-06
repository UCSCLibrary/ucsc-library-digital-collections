require 'zip'
module Hyrax
  class WorksController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    include Ucsc::BreadcrumbsForWorks

    self.curation_concern_type = ::Work
    self.show_presenter = Ucsc::WorkShowPresenter

    skip_authorize_resource :only => [:show, :file_manager, :inspect_work, :manifest, :zip_media_citation]

    def zip_media_citation
      #This feature is currently only implemented for Images
      size = params['size'] || "1000,"
      image_url = Hyrax.config.iiif_image_url_builder.call(presenter.representative_id, nil,size).gsub("localhost","images")
      zip_io = Zip::OutputStream.write_buffer do |zio|
        zio.put_next_entry("image_#{presenter.id}.jpg")
        zio.write(open(image_url, "Cookie" => "_ucsc_hyrax_session=#{cookies[:_ucsc_hyrax_session]}" ).read)
        zio.put_next_entry("citation_#{presenter.id}.txt")
        zio.puts "Citations for #{presenter.title.first}\n"
        zio.puts "APA:"
        zio.puts ActionView::Base.full_sanitizer.sanitize(Hyrax::CitationsBehaviors::Formatters::ApaFormatter.new(self).format(presenter)).strip+"\n"
        zio.puts "MLA:"
        zio.puts ActionView::Base.full_sanitizer.sanitize(Hyrax::CitationsBehaviors::Formatters::MlaFormatter.new(self).format(presenter)).strip+"\n"
        zio.puts "Chicago"
        zio.puts ActionView::Base.full_sanitizer.sanitize(Hyrax::CitationsBehaviors::Formatters::ChicagoFormatter.new(self).format(presenter)).strip+"\n"
      end
      zip_io.rewind
      send_data zip_io.read, :filename => "media_citation_#{presenter.id}.zip", :type => 'application/zip', :disposition => 'attachment'
    end


    def manifest
      headers['Access-Control-Allow-Origin'] = '*'
      @cache_key = "manifest/#{presenter.id}"
      respond_to do |wants|
        wants.json { render json: cached_manifest }
        wants.html { render json: cached_manifest }
      end
    end

    def cached_manifest
#      modified = presenter.solr_document.modified_date || DateTime.now
#      @cache_key = "manifest/#{presenter.id}"
#      if (entry = Rails.cache.send(:read_entry,@cache_key,{})).present?
#        Rails.cache.delete(@cache_key) if (Time.at(entry.instance_variable_get(:@created_at)) < presenter.solr_document.modified)
#      end
#      Rails.cache.fetch(@cache_key){ manifest_builder.to_h.to_json}
      Rails.cache.fetch("manifest/#{presenter.id}"){ manifest_builder.to_h.to_json}
    end


    def deny_access_for_current_user(exception, json_message)
      if (request.format.to_s.include? 'zip')
        render 'hyrax/base/unauthorized', status: :unauthorized, :formats => [:html]
      else
        super
      end
    end

    def deny_access_for_anonymous_user(exception, json_message)
      if (request.format.to_s.include? 'zip')
        session['user_return_to'.freeze] = request.url
        redirect_to main_app.new_user_session_path, alert: exception.message
      else
        super
      end
    end

    def send_email
      @message = Hash.new
      @message[:to] = params[:email]
      @message[:subject] = "#{presenter.page_title}"
      @message[:url] = request.protocol + request.host + "/records/" + params[:id]
      # most basic email regex: something @ something . something
      if "/.+@.+\..+/i".match(@message[:to])
        WorksMailer.work_link_email(@message).deliver_now
        flash.now[:notice] = 'Thank you for your message!'
      else
        flash.now[:error] = 'Please enter a valid email address, and try again.'
      end
      redirect_back fallback_location: {action: show, id: params[:id] }
    rescue RuntimeError => exception
      email_exception_handler(exception)
    end

    def email_exception_handler(exception)
      logger.error("Email Work form failed to send: #{exception.inspect}")
      flash.now[:error] = 'Sorry, this message was not delivered.'
      redirect_back fallback_location: {action: show, id: params[:id] }
    end
  end
end
