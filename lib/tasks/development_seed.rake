desc "create test works for a development environment"

task create_objects: :environment do
  

  puts "simulating upload of sample media files"
  uploaded_images = Dir[Rails.root.join('public','test_images')].map{|path| Hyrax::UploadedFile.create(file:  File.open(path), user: User.first)}
  uploaded_audio = Dir[Rails.root.join('public','test_audio')].map{|path| Hyrax::UploadedFile.create(file:  File.open(path), user: User.first)}

  puts "generating sample metadata"
  schema = ScoobySnacks::METADATA_SCHEMA
  metadata = schema.all_fields.reduce({depositor: User.first.email}) do |field, data|
    if field.controlled?
      key = "#{field.name}_attributes"
      value = {id: field.example}
    else
      key = field.name
      value = field.example
    end
    value = Array.wrap(value) if field.multiple?
    data[key] = value unless data[key].present?    
  end

  puts "creating test collection"
  collection = Collection.create(title: ["Test Collection"], 
                                 depositor: User.first.email, 
                                 collection_type: Hyrax::CollectionType.find_by(title:"User Collection") )
  metadata["member_of_collection_ids"] = [collection.id]

  #puts creating test images
  child_image_1 = Work.create(metadata.merge({title: ["An Image Work that is the First Child of Another Work"],
                                              uploaded_files: [uploaded_images[0]]}))
  child_image_2 = Work.create(metadata.merge({title: ["An Image Work that is the Second Child of Another Work"],
                                              uploaded_files: [uploaded_images[1]]}))
  parent_image = Work.create(metadata.merge({title: ["A Work with Multiple Child Works that are Images"],
                                             ordered_members: [child_image_1,child_image_2]}))
  parent_image = Work.create(metadata.merge({title: ["A Work with Multiple Filesets that are Images"],
                                              uploaded_files: [uploaded_images[2], uploaded_images[3]]}))
  simple_image = Work.create(metadata.merge({title: ["A Simple Image"],
                                              uploaded_files: [uploaded_images[4]]}))


  #puts creating test audio
  child_audio_1 = Work.create(metadata.merge({title: ["An Audio Work that is the First Child of Another work"],
                                              uploaded_files: [uploaded_audio[0]]}))
  child_audio_2 = Work.create(metadata.merge({title: ["An Audio Work that is the Second Child of Another work"],
                                              uploaded_files: [uploaded_audio[1]]}))
  parent_audio = Work.create(metadata.merge({title: ["Work with Multiple Child Works that are Audio"],
                                             ordered_members: [child_audio_1,child_audio_2]}))
  parent_audio = Work.create(metadata.merge({title: ["Work with Multiple Filesets that are Audio"],
                                              uploaded_files: [uploaded_audio[2], uploaded_audio[3]]}))
  simple_audio = Work.create(metadata.merge({title: ["Simple Audio Work"],
                                              uploaded_files: [uploaded_audio[4]]}))

end
