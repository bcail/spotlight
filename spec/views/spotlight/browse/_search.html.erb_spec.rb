require 'spec_helper'

describe 'spotlight/browse/search', :type => :view do
  let(:search) { FactoryGirl.create(:search) }
  let(:exhibit) { FactoryGirl.create(:exhibit) }
  before :each do
    allow(search).to receive_messages(count: 15)
  end

  before :each do
    assign :exhibit, exhibit
  end

  it "should display the image" do
    allow(search).to receive_messages(featured_image: "xyz")
    render partial: 'spotlight/browse/search', locals: { search: search }
    expect(response).to have_selector 'a img'
  end

  it "should have a heading" do
    render partial: 'spotlight/browse/search', locals: { search: search }
    expect(response).to have_link search.title, href: spotlight.exhibit_browse_path(exhibit, search)
  end

  it "should display the item count" do
    render partial: 'spotlight/browse/search', locals: { search: search }
    expect(response).to have_selector ".item-count", text: "#{search.count} items"
  end

  it "should display the short description" do
    allow(search).to receive_messages(short_description: "Short description")
    render partial: 'spotlight/browse/search', locals: { search: search }
    expect(response).to have_selector "p", text: search.short_description
  end
end
