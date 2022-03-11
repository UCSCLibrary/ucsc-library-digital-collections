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

  it "can accept custom visibility settings" do
    collection.visibility = "campus"
    collection.save
    expect(Collection.find(collection.id).visibility).to eq("campus")
    collection.visibility = "request"
    collection.save
    expect(Collection.find(collection.id).visibility).to eq("request")
  end

  describe 'predicates' do
    context '#dateCreated' do
      it 'is BF2:creationDate' do
        expect(work.send(:properties)['dateCreated'].predicate.to_s)
          .to eq('http://id.loc.gov/ontologies/bibframe/creationDate')
      end
    end

    context '#dateCreatedDisplay' do
      it 'is MODS:dateCreated' do
        expect(work.send(:properties)['dateCreatedDisplay'].predicate.to_s)
          .to eq('http://www.loc.gov/mods/rdf/v1#dateCreated')
      end
    end

    context '#dateCreatedIngest' do
      it 'is DC:created' do
        expect(work.send(:properties)['dateCreatedIngest'].predicate.to_s)
          .to eq('http://purl.org/dc/terms/created')
      end
    end
  end
end
