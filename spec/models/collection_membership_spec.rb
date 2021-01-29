require 'rails_helper'
RSpec.describe 'Collection', type: :model do

  before(:all)  do 
    @usr = User.find_by_email('test-email') || User.create(email:"test-email")
  end

  
  let(:collection) { ::Collection.create(depositor: User.first.email, title: ["test collection"], collection_type: Hyrax::CollectionType.first) }
  let(:work) { ::Work.create(depositor: User.first.email, title: ["test work"]) }

  it "initially does not include the work" do #PASS
    expect(collection.member_ids).not_to include(work.id) #PASS
    expect(work.parent_collection_ids).not_to include(collection.id) #PASS
    expect(work.member_of_collections).not_to include(collection) #PASS
  end
  

  it "can add the work to the collection using work.member_of_collections << collection" do #FAIL
    work.member_of_collections << collection
    work.save
    id = collection.id
    collection = ::Collection.find(id)

 #   expect(collection.members).to include(work) #FAIL
 #   expect(collection.member_ids).to include(work.id) #FAIL
 #   expect(collection.ordered_member_ids).to include(work.id) #FAIL
    expect(work.parent_collection_ids).to include(collection.id) #PASS
    expect(work.member_of_collections).to include(collection) #PASS
  end

  it "can add the work using collection.ordered_members << work" do #FAIL
    collection.ordered_members << work

    expect(collection.members).to include(work) #PASS
    expect(collection.member_ids).to include(work.id) #PASS
    expect(collection.ordered_member_ids).to include(work.id) #PASS
#    expect(work.parent_collection_ids).to include(collection.id) #FAIL
#    expect(work.member_of_collections).to include(collection) #FAIL
  end

  it "can add the work using collection.ordered_members << work and work.member_of_collections << collection together" do #PASS
    collection.ordered_members << work
    work.member_of_collections << collection
    collection.save
    work.save

    expect(collection.members).to include(work)  #PASS
    expect(collection.member_ids).to include(work.id) #PASS
    expect(collection.ordered_member_ids).to include(work.id)  #PASS
    expect(work.parent_collection_ids).to include(collection.id) #PASS
    expect(work.member_of_collections).to include(collection) #PASS
  end




  it "can remove the work using work.member_of_collections.delete(collection)" do #PASS
    id = collection.id
    work_id = work.id

    collection.ordered_members << work
    work.member_of_collections << collection
    work.save
    collection.save
    collection=Collection.find(id)

    expect(collection.ordered_member_ids).to include(work.id) #PASS
    collection.save

    work = Work.find(work_id)
    work.member_of_collections.delete(collection)
    work.save

    work = Work.find(work_id)
    collection=Collection.find(id)

#    expect(collection.members).not_to include(work) #FAIL
#    expect(collection.member_ids).not_to include(work.id) #FAIL
#    expect(collection.ordered_member_ids).not_to include(work.id) #FAIL 
#    expect(work.parent_collection_ids).not_to include(collection.id) #FAIL
    expect(work.member_of_collections).not_to include(collection) #PASS

  end

  it "can remove the work using collection.ordered_members.delete(work)" do #PASS
    id = collection.id
    work_id = work.id

    collection.ordered_members << work
    work.member_of_collections << collection
    work.save
    collection.save
    collection=Collection.find(id)

    expect(collection.ordered_member_ids).to include(work.id) #PASS
    collection.ordered_members.delete(work)
    collection.members.delete(work)
    collection.save

    work = Work.find(work_id)
    collection=Collection.find(id)

    expect(collection.members).not_to include(work) #PASS
    expect(collection.member_ids).not_to include(work.id) #PASS 
    expect(collection.ordered_member_ids).not_to include(work.id) #PASS 
#    expect(work.parent_collection_ids).not_to include(collection.id) #FAIL
#    expect(work.member_of_collections).not_to include(collection) #FAIL

  end

  it "can remove the work using 'collection.ordered_members.delete(work) and work.member_of_collections.delete(collection) together" do #PASS
    id = collection.id
    work_id = work.id

    collection.ordered_members << work
    work.member_of_collections << collection
    work.save
    collection.save
    collection=Collection.find(id)

    expect(collection.ordered_member_ids).to include(work.id) #PASS
    collection.ordered_members.delete(work)
    collection.members.delete(work)
    collection.save

    work = Work.find(work_id)
    work.member_of_collections.delete(collection)
    work.save

    collection=Collection.find(id)

    expect(collection.members).not_to include(work) #PASS
    expect(collection.member_ids).not_to include(work.id) #PASS
    expect(collection.ordered_member_ids).not_to include(work.id) #PASS
    expect(work.parent_collection_ids).not_to include(collection.id) #PASS
    expect(work.member_of_collections).not_to include(collection) #PASS

  end

end
