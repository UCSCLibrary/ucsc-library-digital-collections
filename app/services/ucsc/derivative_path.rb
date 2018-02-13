module Ucsc
  class DerivativePath < Hyrax::DerivativePath
    
    private

    def extension
        case destination_name
        when *['thumbnail','small','medium','large','square','fullsize']
          ".#{MIME::Types.type_for('jpg').first.extensions.first}"
        else
          ".#{destination_name}"
        end
    end

  end
end
