require 'rails_helper'

RSpec.describe "pages/index", :type => :view do
  before(:each) do
    assign(:pages, [
      Page.create!(
        :doc => nil,
        :subject => "Subject",
        :body => "MyText",
        :order_index => 1
      ),
      Page.create!(
        :doc => nil,
        :subject => "Subject",
        :body => "MyText",
        :order_index => 1
      )
    ])
  end

  it "renders a list of pages" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Subject".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
