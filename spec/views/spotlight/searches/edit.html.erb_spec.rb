require 'spec_helper'

describe "spotlight/searches/edit.html.erb", :type => :view do
  
  let(:blacklight_config) do
    Blacklight::Configuration.new do |config|
      config.add_facet_field :some_field
    end
  end
  let(:exhibit) { FactoryGirl.create(:exhibit) }
  let(:search) { stub_model(Spotlight::Search, exhibit: exhibit,
        id: 99, title: "Title1", short_description: "MyText", query_params: { f: { "some_field" => ["xyz"]}}) }
  before do
    allow(view).to receive(:search_action_path).and_return("/search")
    allow(view).to receive(:exhibit_search_path).and_return("/search")
    allow(view).to receive(:exhibit_searches_path).and_return("/searches")
    allow(view).to receive(:blacklight_config).and_return(blacklight_config)
    assign(:exhibit, exhibit)
    assign(:search, search)
    allow(view).to receive(:current_exhibit).and_return(exhibit)
  end

  it "renders active search constraints" do
    render
    expect(rendered).to have_selector '.appliedFilter .constraint-value'
    expect(rendered).to have_selector '.appliedFilter .constraint-value .filterName', text: "Some Field"
    expect(rendered).to have_selector '.appliedFilter .constraint-value .filterValue', text: "xyz"
  end
end