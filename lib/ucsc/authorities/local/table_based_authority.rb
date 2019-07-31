module Ucsc::Authorities::Local
  class TableBasedAuthority < Qa::Authorities::Local::TableBasedAuthority

    def find(uri)
      record = base_relation.find_by(uri: uri)
      return unless record
      output(record)
    end

    def search(q)
      qq = Mysql2::Client.escape(q)
      # first entries include full query all together
      entries = base_relation.where("lower(label) like '%#{ qq}%'").limit(25)

      words = q.gsub(/\s+/m, ' ').strip.split(" ").map{|word|  Mysql2::Client.escape(word)}
      if words.count > 1 
        # next entries include all words
        entries += base_relation.where("lower(label) like '%" + words.join("%' AND '%") + "%'").limit(25)
        # entries with any of the words are included at the end
        entries += base_relation.where("lower(label) like '%" + words.join("%' OR '%") + "%'").limit(25)
      end
      
      output_set(entries.uniq)
    end

    private

      def output(item)
        { id: url_for(item[:uri]), label: item[:label] }.with_indifferent_access
      end

      def url_for(id)
        root_urls = {production: "https://digitalcollections.library.ucsc.edu",
                     staging: "http://digitalcollections-staging.library.ucsc.edu",
                     development: "http://#{Socket.gethostname}",
                     test: "http://#{Socket.gethostname}"}
        return "#{root_urls[Rails.env.to_sym]}/authorities/show/local/#{subauthority}/#{id}"
      end

  end
end
