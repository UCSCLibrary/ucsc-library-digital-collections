require 'rails_helper'

RSpec.describe FileSet do

  it "recognizes custom mimetypes" do
    expect(FileSet.audio_mime_types).to eq(SamveraHls::FileSetBehavior.audio_mime_types)
    expect(FileSet.audio_mime_types).to include('audio/x-aiff')
  end
  
end
