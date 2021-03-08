require 'rails_helper'

RSpec.describe UserAccessGrant do
  let(:usr1) {User.find_by_email('test@example.com') || User.create(email:"test@example.com", password: "password")}
  let(:usr2) {User.find_by_email('test2@example.com') || User.create(email:"test2@example.com", password: "password")}
  let(:work) {Work.create(depositor: usr1.email, title:["test title"])}

  it "can be accessed by the User object" do
    UserAccessGrant.create(user_id: usr2.id, object_id: work.id, start: DateTime.now, end: 2.days.from_now)
    expect(usr2.current_access_grants).to include(work.id)
  end
  
end
