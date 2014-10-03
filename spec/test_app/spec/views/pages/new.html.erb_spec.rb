require 'rails_helper'

RSpec.describe "pages/new", :type => :view do
  before(:each) do
    assign(:page, Page.new(
      :doc => nil,
      :subject => "MyString",
      :body => "MyText",
      :order_index => 1
    ))
  end

  it "renders new page form" do
    render

    assert_select "form[action=?][method=?]", pages_path, "post" do

      assert_select "input#page_doc_id[name=?]", "page[doc_id]"

      assert_select "input#page_subject[name=?]", "page[subject]"

      assert_select "textarea#page_body[name=?]", "page[body]"

      assert_select "input#page_order_index[name=?]", "page[order_index]"
    end
  end
end
