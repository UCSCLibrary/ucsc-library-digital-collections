module Ucsc::Authorities::Local
  class TableBasedAuthority < Qa::Authorities::Local::TableBasedAuthority

    def find(uri)
      record = base_relation.find_by(uri: uri)
      return unless record
      ucsc_output(record)
    end

    private

      def ucsc_output(item)
        { id: url_for(item[:uri]), label: item[:label] }.with_indifferent_access
      end

      def url_for(id)
        hostname = Socket.gethostname
        protocol = Rails.env.production? ? "https" : "http"
        return "#{protocol}://#{hostname}/authorities/show/local/#{subauthority}/#{id}"
      end

  end
end
