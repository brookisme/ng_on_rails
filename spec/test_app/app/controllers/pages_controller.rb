class PagesController < ApplicationController
  before_action :set_page, only: [:show, :edit, :update, :destroy]

  def index
    @pages = Page.all
  end
  
  def show
  end

  def new
    @page = Page.new
  end

  def create
    @page = Page.new(page_params)
    puts "params>>>>>>>>>>>>>"
    puts "#{params.to_json}"
    puts "page_params.to_json>>>>>>>>>>>>>"
    puts "#{page_params.to_json}"

    respond_to do |format|
      if @page.save
        format.html { redirect_to @page, notice: 'Page was successfully created.' }
        format.json { render action: 'show', status: :created, location: @page }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @page.update_attributes(page_params)
        format.html { redirect_to @page, notice: 'Page was successfully updated.' }
        format.json { render action: 'show', status: :created, location: @page }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @page.destroy
    respond_to do |format|
      format.html { redirect_to pages_url, notice: 'Page was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

private

  def set_page
    @page = Page.find(params[:id])
  end

  def set_doc
    @doc = Doc.where(id: params[:doc_id]).first
  end

  def page_params
    params.require(:page).permit(
      :id,
      :_destroy,
      :subject,
      :body,
      :order_index,
      :doc_id
    )
  end
end
