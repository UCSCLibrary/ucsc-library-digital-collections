require 'socket'

Hyrax.config do |config|


  # Injected via `rails g hyrax:work Course`
  config.register_curation_concern :course
  # Injected via `rails g hyrax:work Lecture`
  config.register_curation_concern :lecture
  # Injected via `rails g hyrax:work Work`
  config.register_curation_concern :work
  # Email recipient of messages sent via the contact form


  # Register roles that are expected by your implementation.
  # @see Hyrax::RoleRegistry for additional details.
  # @note there are magical roles as defined in Hyrax::RoleRegistry::MAGIC_ROLES
  # config.register_roles do |registry|
  #   registry.add(name: 'captaining', description: 'For those that really like the front lines')
  # end

  # When an admin set is created, we need to activate a workflow.
  # The :default_active_workflow_name is the name of the workflow we will activate.
  # @see Hyrax::Configuration for additional details and defaults.
   config.default_active_workflow_name = 'ucsc_generic_ingest'

  # Email recipient of messages sent via the contact form
  config.contact_email = "speccoll@library.ucsc.edu"

  # Text prefacing the subject entered in the contact form
  config.subject_prefix = "UCSC Digital Collections inquiry:"

  # How many notifications should be displayed on the dashboard
  # config.max_notifications_for_dashboard = 5

  # How often clients should poll for notifications
  # config.notifications_update_poll_interval = 30.seconds

  # How frequently should a file be fixity checked
  # config.max_days_between_fixity_checks = 7

  # Enable displaying usage statistics in the UI
  # Defaults to false
  # Requires a Google Analytics id and OAuth2 keyfile.  See README for more info
  config.analytics = true

  # Google Analytics tracking ID to gather usage statistics
  config.google_analytics_id = 'G-9SL44KPY4G'

  # Date you wish to start collecting Google Analytic statistics for
  # Leaving it blank will set the start date to when ever the file was uploaded by
  # NOTE: if you have always sent analytics to GA for downloads and page views leave this commented out
  # config.analytic_start_date = DateTime.new(2014, 9, 10)
  config.analytic_start_date = DateTime.new(2017,5,24)

  # Enables a link to the citations page for a work
  # Default is false
  config.citations = false

  # Where to store tempfiles, leave blank for the system temp directory (e.g. /tmp)
  # config.temp_file_base = '/home/developer1'

  # Hostpath to be used in Endnote exports
  config.persistent_hostpath = 'http://localhost/records/'

  # If you have ffmpeg installed and want to transcode audio and video set to true
  config.enable_ffmpeg = true

  # Hyrax uses NOIDs for files and collections instead of Fedora UUIDs
  # where NOID = 10-character string and UUID = 32-character string w/ hyphens
  # config.enable_noids = true

  # Template for your repository's NOID IDs
  # config.noid_template = ".reeddeeddk"

  # Use the database-backed minter class
  # config.noid_minter_class = ActiveFedora::Noid::Minter::Db

  # Store identifier minter's state in a file for later replayability

  if Rails.env.development? or Rails.env.test?
    config.minter_statefile = '/srv/minter-state'
  else
    config.minter_statefile = '/srv/ucsc_sufia/minter-state'
  end

  # Prefix for Redis keys
  # config.redis_namespace = "hyrax"

  # Path to the file characterization tool
  if Rails.env.development?
    config.fits_path = ENV['FITS_PATH'] || "/srv/fits/fits.sh"
  else
    config.fits_path = "/usr/share/fits/fits.sh"
  end

  # Path to the file derivatives creation tool
  # config.libreoffice_path = "soffice"

  # How many seconds back from the current time that we should show by default of the user's activity on the user's dashboard
  # config.activity_to_show_default_seconds_since_now = 24*60*60

  # Hyrax can integrate with Zotero's Arkivo service for automatic deposit
  # of Zotero-managed research items.
  # config.arkivo_api = false

  # Location autocomplete uses geonames to search for named regions
  # Username for connecting to geonames
  # config.geonames_username = ''

  # Should the acceptance of the licence agreement be active (checkbox), or
  # implied when the save button is pressed? Set to true for active
  # The default is true.
  # config.active_deposit_agreement_acceptance = true

  # Should work creation require file upload, or can a work be created first
  # and a file added at a later time?
  # The default is true.
  config.work_requires_files = false

  # Enable IIIF image service. This is required to use the
  # UniversalViewer-ified show page
  #
  # If you have run the riiif generator, an embedded riiif service
  # will be used to deliver images via IIIF. If you have not, you will
  # need to configure the following other configuration values to work
  # with your image server:
  #
  #   * iiif_image_url_builder
  #   * iiif_info_url_builder
  #   * iiif_image_compliance_level_uri
  #   * iiif_image_size_default
  #
  # Default is false
   config.iiif_image_server = true

   # If we have an external IIIF server, use it for image requests; else, use riiif
   config.iiif_image_url_builder = lambda do |fileset_id, base_url, size, region="full", rotation="0"|
     if fileset_id.present?
       if fileset_id.split("files").count > 1
         # When we were taking images directly from Fedora, we would pass
         # "#{file_set.id}/files/#{file_set.original_file.id}"
         # as a fileset_id to locate the original file binary in Fedora
         # Here we include a hack to take the fileset.id from the old syntax
         fid = fileset_id[0..8]
       else
         fid = fileset_id
       end

       # Divide the file id with underscores for the image server to handle more easily
       encoded_id = "#{fid[0..1]}_#{fid[2..3]}_#{fid[4..5]}_#{fid[6..7]}_#{fid[8]}"

       unless (image_server_root_url = ENV['IIIF_SERVER_URL'])
         suffix = ["production","staging"].include?(Rails.env.to_s) ? "" : "staging/"
         image_server_root_url = "https://digitalcollections-image.library.ucsc.edu/#{suffix}iiif/2/"
       end

       iiif_url = File.join(image_server_root_url,
         encoded_id,
         region,
         size,
         rotation,
         "default.jpg")
       Rails.logger.debug "event: iiif_image_request: #{iiif_url}"
       iiif_url
     else
       ""
     end
   end

   # If we have an external IIIF server, use it for info.json; else, use riiif
   config.iiif_info_url_builder = lambda do |fileset_id, base_url|
     if fileset_id.present?
       if fileset_id.split("files").count > 1
         fileset_id = fileset_id[0..8]
       end
       fid=fileset_id
       unless (image_server_root_url = ENV['IIIF_SERVER_URL'])
         suffix = ["production","staging"].include?(Rails.env.to_s) ? "" : "staging/"
         image_server_root_url = "https://digitalcollections-image.library.ucsc.edu/#{suffix}iiif/2/"
       end
       # Divide the file id with underscores for the image server to handle more easily
       encoded_id = "#{fid[0..1]}_#{fid[2..3]}_#{fid[4..5]}_#{fid[6..7]}_#{fid[8]}"
       File.join(image_server_root_url,encoded_id)
     else
       ""
     end
   end

  # Returns a URL that indicates your IIIF image server compliance level
  # config.iiif_image_compliance_level_uri = 'http://iiif.io/api/image/2/level2.json'

  # Returns a IIIF image size default
  # config.iiif_image_size_default = '600,'


  # Should a button with "Share my work" show on the front page to all users (even those not logged in)?
  config.display_share_button_when_not_logged_in = false

  # The user who runs batch jobs. Update this if you aren't using emails
  # config.batch_user_key = 'batchuser@example.com'

  # The user who runs fixity check jobs. Update this if you aren't using emails
  # config.audit_user_key = 'audituser@example.com'
  #
  # The banner image. Should be 5000px wide by 1000px tall
  # config.banner_image = 'https://cloud.githubusercontent.com/assets/92044/18370978/88ecac20-75f6-11e6-8399-6536640ef695.jpg'
  # config.banner_image = ''
  # image server


  # Temporary paths to hold uploads before they are ingested into FCrepo
  # These must be lambdas that return a Pathname. Can be configured separately
  config.upload_path = ->() { Pathname.new("/dams_derivatives/tmp/#{Rails.env}") }
  config.cache_path  = ->() { Pathname.new("/dams_derivatives/tmp/#{Rails.env}/cache") }

  # Location on local file system where derivatives will be stored
  # If you use a multi-server architecture, this MUST be a shared volume
  config.derivatives_path = "/dams_derivatives/#{Rails.env}"
  config.derivatives_path = "/dams_derivatives/production" if Rails.env.to_s == "staging"

  # Should schema.org microdata be displayed?
  # config.display_microdata = true

  # What default microdata type should be used if a more appropriate
  # type can not be found in the locale file?
  # config.microdata_default_type = 'http://schema.org/CreativeWork'

  # Should the media display partial render a download link?
 #  config.display_media_download_link = true
  config.display_media_download_link = false

  # A configuration point for changing the behavior of the license service
  #   @see Hyrax::LicenseService for implementation details
  # config.license_service_class = Hyrax::LicenseService

  # Labels for permission levels
  # config.permission_levels = { "Choose Access" => "none", "View/Download" => "read", "Edit" => "edit" }

  # Labels for owner permission levels
  # config.owner_permission_levels = { "Edit Access" => "edit" }

  # Returns a lambda that takes a hash of attributes and returns a string of the model
  # name. This is called by the batch upload process
  # config.model_to_create = ->(_attributes) { Hyrax.primary_work_type.model_name.name }

  # Path to the ffmpeg tool
  # config.ffmpeg_path = 'ffmpeg'

  # Max length of FITS messages to display in UI
  # config.fits_message_length = 5

  # ActiveJob queue to handle ingest-like jobs
  # config.ingest_queue_name = :default

  ## Attributes for the lock manager which ensures a single process/thread is mutating a ore:Aggregation at once.
  # How many times to retry to acquire the lock before raising UnableToAcquireLockError
  # config.lock_retry_count = 600 # Up to 2 minutes of trying at intervals up to 200ms
  #
  # Maximum wait time in milliseconds before retrying. Wait time is a random value between 0 and retry_delay.
  # config.lock_retry_delay = 200
  #
  # How long to hold the lock in milliseconds
  # config.lock_time_to_live = 60_000

  ## Do not alter unless you understand how ActiveFedora handles URI/ID translation
  # config.translate_id_to_uri = ActiveFedora::Noid.config.translate_id_to_uri
  # config.translate_uri_to_id = ActiveFedora::Noid.config.translate_uri_to_id

  ## Fedora import/export tool
  #
  # Path to the Fedora import export tool jar file
  # config.import_export_jar_file_path = "tmp/fcrepo-import-export.jar"
  #
  # Location where descriptive rdf should be exported
  # config.descriptions_directory = "tmp/descriptions"
  #
  # Location where binaries are exported
  # config.binaries_directory = "tmp/binaries"

  # If browse-everything has been configured, load the configs.  Otherwise, set to nil.
  begin
    if defined? BrowseEverything
      config.browse_everything = BrowseEverything.config
    else
      Rails.logger.warn "BrowseEverything is not installed"
    end
  rescue Errno::ENOENT
    config.browse_everything = nil
  end
end

Date::DATE_FORMATS[:standard] = "%m/%d/%Y"

Qa::Authorities::Local.register_subauthority('dcmi_types', 'Ucsc::Authorities::Local::TableBasedAuthority')
Qa::Authorities::Local.register_subauthority('agents', 'Ucsc::Authorities::Local::TableBasedAuthority')
Qa::Authorities::Local.register_subauthority('places', 'Ucsc::Authorities::Local::TableBasedAuthority')
Qa::Authorities::Local.register_subauthority('time_periods', 'Ucsc::Authorities::Local::TableBasedAuthority')
Qa::Authorities::Local.register_subauthority('topics', 'Ucsc::Authorities::Local::TableBasedAuthority')
Qa::Authorities::Local.register_subauthority('formats', 'Ucsc::Authorities::Local::TableBasedAuthority')
Qa::Authorities::Local.register_subauthority('genres', 'Ucsc::Authorities::Local::TableBasedAuthority')

Qa::Authorities::Geonames.username = 'UCSC_Library_DI'


Rails.application.config.to_prepare do

  Hyrax::Dashboard::CollectionsController.presenter_class = Ucsc::CollectionPresenter

  Hyrax::ContactForm.class_eval do
    def self.issue_types_for_locale
      [
        "Reporting a Problem",
        "General Inquiry or Request"
      ]
    end
  end

  # never display the "share your work" button on the homepage
  Hyrax::HomepagePresenter.class_eval do
    def display_share_button?
      false
    end
  end

  OAI::Provider::Response::RecordResponse.class_eval do
    def header_for(record)
      param = Hash.new
      param[:status] = 'deleted' if deleted?(record)
      @builder.header param do
        @builder.identifier record.id
        @builder.type record.human_readable_type
        @builder.datestamp timestamp_for(record)

        record.collection_ids.each do |id|
          @builder.isPartOf id
        end

        sets_for(record).each do |set|
          @builder.setSpec set.spec
         end
      end
    end
  end

  # set bulkrax default work type to first curation_concern if it isn't already set
  if Bulkrax.default_work_type.blank?
    Bulkrax.default_work_type = Hyrax.config.curation_concerns.first.to_s
  end
end
