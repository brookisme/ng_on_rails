require 'rails_helper'

RSpec.describe "docs/edit", :type => :view do
  before(:each) do
    @doc = assign(:doc, Doc.create!(
      :name => "MyString",
      :description => "MyString"
    ))
  end

  it "renders the edit doc form" do
    render

    assert_select "form[action=?][method=?]", doc_path(@doc), "post" do

      assert_select "input#doc_name[name=?]", "doc[name]"

      assert_select "input#doc_description[name=?]", "doc[description]"
    end
  end
end
