class Hydra::Derivatives::Processors::Jpeg2kImage

  def process
      image = MiniMagick::Image.open(source_path)
      quality = image['%[channels]'] == 'gray' ? 'gray' : 'color'
      long_dim = self.class.long_dim(image)
      to_srgb = directives.fetch(:to_srgb, true)
      preprocess(image, resize: directives[:resize], to_srgb: to_srgb, src_quality: quality)
      if image.mime_type.to_s.include?('tif')
        file_path = self.class.tmp_file('.tif')
        image.format 'tif'
        image.compress 'none'
      elsif image.mime_type.to_s.include?('jpeg') || image.mime_type.to_s.include?('jpg')
        file_path = self.class.tmp_file('.jp2')
        image.format 'jp2'
      end
      image.write file_path
      recipe = self.class.kdu_compress_recipe(directives, quality, long_dim)
      encode_file(recipe, file_path: file_path)
      File.unlink(file_path) unless file_path.nil?
  end

  protected

    def preprocess(image, opts = {})
      image.combine_options do |c|
        c.auto_orient
        c.resize(opts[:resize]) if opts[:resize]
        c.profile self.class.srgb_profile_path if opts[:src_quality] == 'color' && opts[:to_srgb]
      end
      image
    end
end


module CarrierWave
  class SanitizedFile

    def copy!(new_path)
      temp_filename = File.join(Dir.tmpdir, "hycruz_ingest_tempfile-#{Time.now.strftime("%Y%m%d")}-#{$$}-#{rand(0x100000000).to_s(36)}")
      FileUtils.cp(path, temp_filename)
      FileUtils.mv(temp_filename, new_path)
    end

  end
end


unless ["development","test"].include? ENV['RAILS_ENV']
  class Hyrax::CollectionPresenter
    def permission_badge_class
      Ucsc::PermissionBadge
    end
  end
end

module FileUtilsPatch
  def copy_file(dest)
    FileUtils.touch(path())
    super
  end
end

module FileUtils
  class Entry_
    prepend FileUtilsPatch
  end
end
