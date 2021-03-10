require 'zip'
module Hyrax
  class WorksController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    include Ucsc::BreadcrumbsForWorks

    self.curation_concern_type = ::Work

    # This tells the system to use our customized presenter instead of Hyrax's default one
    self.show_presenter = Ucsc::WorkShowPresenter

    # This skips the default authorization step defined by devise
    # because we display these to public users, but we still enforce permissions elsewhere
    skip_authorize_resource :only => [:show, :file_manager, :inspect_work, :manifest, :zip_media_citation, :send_email]

    # This custom action delivers a zip file containing a representative image and citation information for a work
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

    # This overrides the parent function that handles denying access to unauthorized folks.
    # We need to explicitly handle requests for zip format files, or we get an error.
    def deny_access_for_current_user(exception, json_message)
      if (request.format.to_s.include? 'zip')
        render 'hyrax/base/unauthorized', status: :unauthorized, :formats => [:html]
      else
        super
      end
    end

    # This overrides the parent function that handles denying access to unauthorized folks.
    # We need to explicitly handle requests for zip format files, or we get an error.    
    def deny_access_for_anonymous_user(exception, json_message)
      if (request.format.to_s.include? 'zip')
        session['user_return_to'.freeze] = request.url
        redirect_to main_app.new_user_session_path, alert: exception.message
      else
        super
      end
    end

    # This action allows users to email themselves a citation for a work
    def send_email
      @message = Hash.new
      @message[:to] = params[:email]
      @message[:subject] = "#{presenter.page_title}"
      @message[:url] = request.protocol + request.host_with_port + "/records/" + params[:id]
      # most basic email regex: something @ something . something
      if @message[:to].match(/.+@.+\..+/i)
        WorksMailer.work_link_email(@message).deliver_now
        @flash_message = 'Your email has been sent.'
      else
        @flash_message = 'Please enter a valid email address, and try again.'
      end
      redirect_to @message[:url], notice: @flash_message
    rescue RuntimeError => exception
      email_exception_handler(exception)
    end

    def email_exception_handler(exception)
      logger.error("Email Work form failed to send: #{exception.inspect}")
      @flash_message = 'Sorry, this message was not delivered.'
      redirect_back fallback_location: {action: show, id: params[:id] }
    end

  end
end
