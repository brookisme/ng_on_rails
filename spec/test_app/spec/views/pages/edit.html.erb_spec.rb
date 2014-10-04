require 'rails_helper'

RSpec.describe "pages/edit", :type => :view do
  before(:each) do
    @page = assign(:page, Page.create!(
      :doc => nil,
      :subject => "MyString",
      :body => "MyText",
      :order_index => 1
    ))
  end

  it "renders the edit page form" do
    render

    assert_select "form[action=?][method=?]", page_path(@page), "post" do

      assert_select "input#page_doc_id[name=?]", "page[doc_id]"

      assert_select "input#page_subject[name=?]", "page[subject]"

      assert_select "textarea#page_body[name=?]", "page[body]"

      assert_select "input#page_order_index[name=?]", "page[order_index]"
    end
  end
end
