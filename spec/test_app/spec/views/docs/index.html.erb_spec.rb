require 'rails_helper'

RSpec.describe "docs/index", :type => :view do
  before(:each) do
    assign(:docs, [
      Doc.create!(
        :name => "Name",
        :description => "Description"
      ),
      Doc.create!(
        :name => "Name",
        :description => "Description"
      )
    ])
  end

  it "renders a list of docs" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
  end
end
