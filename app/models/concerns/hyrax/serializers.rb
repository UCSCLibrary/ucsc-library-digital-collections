module Hyrax
  module Serializers
    def to_s
      if title.respond_to?(:each)
        title.join(' | ')
      elsif title.present?
        title
      elsif label.present?
        label
      else
        'No Title'
      end
    end
  end
end
