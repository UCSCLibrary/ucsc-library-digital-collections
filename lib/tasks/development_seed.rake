desc "create test works for a development environment"

task create_objects: :environment do 

  user = User.first
  ability = user.ability
  puts "simulating upload of sample media files"
  uploaded_images = Dir[Rails.root.join('public','example_media','images','*')].map{|path| Hyrax::UploadedFile.create(file:  File.open(path), user: user)}
  uploaded_audio = Dir[Rails.root.join('public','example_media','audio','*')].map{|path| Hyrax::UploadedFile.create(file:  File.open(path), user: user)}

  puts "generating sample metadata"
  schema = ScoobySnacks::METADATA_SCHEMA
  metadata = schema.all_fields.reduce({depositor: user.email}) do |metadata,field|
    if field.controlled?
      key = "#{field.name}_attributes"
      value = {id: field.example}
    else
      key = field.name
      value = field.example
    end
    value = Array.wrap(value) if field.multiple?
    metadata[key] = value unless metadata[key].present?
    metadata
  end

  example_collection_title = "Example Collection"
  if( existing_collections = Collection.where(title: example_collection_title) ).present?
    collection = existing_collections.first
  else
    collection =  Collection.create(title: [example_collection_title], 
                                    depositor: user.email,
                                    collection_type: Hyrax::CollectionType.find_by(title:"User Collection") )
  end
 
  metadata["member_of_collection_ids"] = [collection.id]

  attributes = [
    {title: ["An Image Work that is the First Child of Another Work"], uploaded_files: [uploaded_images[0]], type: :image, rel: :child},
    {title: ["An Image Work that is the Second Child of Another Work"], uploaded_files: [uploaded_images[4]], type: :image, rel: :child},
    {title: ["An Audio Work that is the First Child of Another work"], uploaded_files: [uploaded_audio[0]], type: :audio, rel: :child},
    {title: ["An Audio Work that is the Second Child of Another work"], uploaded_files: [uploaded_audio[1]], type: :audio, rel: :child},
    {title: ["A Simple Public Image"], visibility: "open", uploaded_files: [uploaded_images[1]], type: :image},
    {title: ["A Simple Private Image"], visibility: "restricted",uploaded_files: [uploaded_images[1]], type: :image},
    {title: ["Simple Audio Work"], uploaded_files: [uploaded_audio[4]], type: :audio},
    {title: ["A Work with Multiple Filesets that are Images"], uploaded_files: [uploaded_images[2].id, uploaded_images[3].id], type: :image},
    {title: ["Work with Multiple Filesets that are Audio"], uploaded_files: [uploaded_audio[2].id, uploaded_audio[3].id], type: :audio},
    {title: ["A Work with Multiple Child Works that are Images"], type: :image, rel: :parent},
    {title: ["Work with Multiple Child Works that are Audio"], type: :audio, rel: :parent}
  ]
  
  child_image_works = []
  child_audio_works = []
  attributes.each_with_index do |atts, i| 
    if atts[:rel] == :child
      work_action = :update
      work = Work.create(atts.merge({depositor: user.email}).except(:uploaded_files, :type, :rel))
      child_image_works << work if atts[:type] == :image 
      child_audio_works << work if atts[:type] == :audio 
    else
      work_action = :create
      work = Work.new
    end
    if atts[:rel] == :parent
      work_action = :update
      work = Work.create(atts.merge({depositor: user.email}).except(:uploaded_files, :type, :rel))
      work.ordered_members = (atts[:type] == image) ? child_image_works : child_audio_works
      work.save
    end
    env = Hyrax::Actors::Environment.new(work, ability, metadata.merge(atts.except(:rel, :type))) 
    Hyrax::CurationConcern.actor.send(work_action,env)
  end

  
end
