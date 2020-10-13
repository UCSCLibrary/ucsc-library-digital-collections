class Hydra::Derivatives::Processors::Jpeg2kImage

  def process
      image = MiniMagick::Image.open(source_path)
      quality = image['%[channels]'] == 'gray' ? 'gray' : 'color'
      long_dim = self.class.long_dim(image)
      file_path = self.class.tmp_file('.tif')
      to_srgb = directives.fetch(:to_srgb, true)
      preprocess(image, resize: directives[:resize], to_srgb: to_srgb, src_quality: quality)
      if image.mime_type.to_s.include?('tif')
        image.format 'tif'
        image.compress 'none'
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
