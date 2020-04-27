require 'rails_helper'
RSpec.describe 'Collection', type: :model do
  let(:user){User.create(email:"ethenry@ucsc.edu", password: "thistestpass")}
  let(:collection) { ::Collection.create(depositor: user.email, title: ["test collection"], collection_type: Hyrax::CollectionType.find_or_create_default_collection_type) }
  let(:work) { ::Work.create(depositor: User.first.email, title: ["test work"]) }
  let(:schema) {ScoobySnacks::METADATA_SCHEMA}
  let(:standard_field) {schema.get_field "description"}
  let(:scalar_field) {schema.get_field "titleAlternative"}
  let(:controlled_field) {schema.get_field "subjectTopic"}

  it "saves standard hyrax metadata fields in fedora" do
    collection.send("#{standard_field.name}=".to_sym,Array.wrap(standard_field.example))
    collection.save
    expect(::Collection.find(collection.id).send(standard_field.name.to_sym)).to include(standard_field.example)
  end
  
  it "indexes standard hyrax metadata fields in solr" do
    collection.send("#{standard_field.name}=".to_sym,Array.wrap(standard_field.example))
    collection.save
    expect(SolrDocument.find(collection.id).send(standard_field.name.to_sym)).to include(standard_field.example)
  end
  
  it "supports scalar custom metadata fields" do
    collection.send("#{scalar_field.name}=".to_sym,Array.wrap(scalar_field.example))
    collection.save
    expect(SolrDocument.find(collection.id).send(scalar_field.name.to_sym)).to include(scalar_field.example)
  end
  
  it "supports controlled custom metadata fields" do
    collection.send("#{controlled_field.name}_attributes=".to_sym,[{id: controlled_field.example}])
    label = ::WorkIndexer.fetch_remote_label(controlled_field.example)
    collection.save
    expect(SolrDocument.find(collection.id).send(controlled_field.name.to_sym)).to include(label)
  end
  
end
