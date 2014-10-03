require 'rails_helper'

RSpec.describe "docs/new", :type => :view do
  before(:each) do
    assign(:doc, Doc.new(
      :name => "MyString",
      :description => "MyString"
    ))
  end

  it "renders new doc form" do
    render

    assert_select "form[action=?][method=?]", docs_path, "post" do

      assert_select "input#doc_name[name=?]", "doc[name]"

      assert_select "input#doc_description[name=?]", "doc[description]"
    end
  end
end
