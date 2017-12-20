require 'rails_helper'
RSpec.describe 'records/edit_fields/_autosuggest.html.erb', type: :view do
  let(:work) { Work.new }
  let(:form) { Hyrax::WorkForm.new(work, nil, controller) }
  let(:form_template) do
    %(
      <%= simple_form_for [main_app, @form] do |f| %>
        <%= render "records/edit_fields/autosuggest", 
                   f:  f, 
                   key:  'creator',
                   property: {'input' => "autosuggest",
                              "vocabularies" => [{"authority" => "loc", 
                                                  "subauthority" => "names"},
                                                 {"authority" => "local", 
                                                  "subauthority" => "agents"}]},
                   default_options:  {required: false,
                                     input_html: { class: 'form-control', 
                                                   multiple: true } } %>
      <% end %>
    )
  end

  before do
    assign(:form, form)
    render inline: form_template
  end

  it 'has an input of some kind' do
    expect(rendered).to have_selector('input')
  end
end
