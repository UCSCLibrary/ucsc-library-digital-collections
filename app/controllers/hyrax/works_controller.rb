require 'zip'
module Hyrax
  class WorksController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    include Ucsc::BreadcrumbsForWorks

    self.curation_concern_type = ::Work
    self.show_presenter = Ucsc::WorkShowPresenter


    def zip_media_citation
      #This feature is currently only implemented for Images
      size = params['size'] || "1000,"
      image_url = Hyrax.config.iiif_image_url_builder.call(presenter.representative_id, nil,size).gsub("localhost","images")
      zip_io = Zip::OutputStream.write_buffer do |zio|
        zio.put_next_entry("image_#{presenter.id}.jpg")
        zio.write(open(image_url).read)
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
      send_data zip_io.read, :filename => "media_citation_#{presenter.id}.zip"
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
  end
end
