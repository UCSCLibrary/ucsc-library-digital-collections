class Hydra::Derivatives::Processors::Jpeg2kImage

def process
      image = MiniMagick::Image.open(source_path)
      quality = image['%[channels]'] == 'gray' ? 'gray' : 'color'
      long_dim = self.class.long_dim(image)
      file_path = self.class.tmp_file('.tif')
      to_srgb = directives.fetch(:to_srgb, true)
      if directives[:resize] || to_srgb
        preprocess(image, resize: directives[:resize], to_srgb: to_srgb, src_quality: quality)
      end
      image.format 'tif'
      image.compress 'none'
      image.write file_path
      recipe = self.class.kdu_compress_recipe(directives, quality, long_dim)
      encode_file(recipe, file_path: file_path)
      File.unlink(file_path) unless file_path.nil?
    end

end
