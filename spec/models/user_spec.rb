require 'rails_helper'

RSpec.describe User do
  let(:usr) {User.find_by_email('test@example.com') || User.create(email:"test@example.com", password: "password")}

  it "uses email address to represent itself as a string" do
    expect(usr.to_s).to eq(usr.email)
  end
  
end
