module Hydra::Works
  class CharacterizationService
    def append_property_value (property, value)
      return if (property == :mime_type) && (value.to_s.include? "excel") && (object.mime_type.present?)
      value = object.send(property) + [value] unless property.to_s == "mime_type"
      # We don't want multiple heights / widths, pick the max
      value = value.map(&:to_i).max.to_s if property == :height || property == :width
      object.send("#{property}=", value)
    end
  end
end
