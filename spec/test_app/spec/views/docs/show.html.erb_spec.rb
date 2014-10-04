require 'rails_helper'

RSpec.describe "docs/show", :type => :view do
  before(:each) do
    @doc = assign(:doc, Doc.create!(
      :name => "Name",
      :description => "Description"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Description/)
  end
end
