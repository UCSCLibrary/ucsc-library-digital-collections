module Ucsc::Authorities::Local
  class TableBasedAuthority < Qa::Authorities::Local::TableBasedAuthority

    def find(uri)
      record = base_relation.find_by(uri: uri)
      return unless record
      ucsc_output(record)
    end

    def search(q)
      # first entries include full query all together
      entries = base_relation.where("lower(label) like '%#{q}%'").limit(25)

      # next entries include all words
      words = q.gsub(/\s+/m, ' ').strip.split(" ")
      entries += base_relation.where("lower(label) like '%" + words.join("%' AND '%") + "%'").limit(25)

      # entries with any of the words are included at the end
      entries += base_relation.where("lower(label) like '%" + words.join("%' OR '%") + "%'").limit(25)

      output_set(entries)
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
