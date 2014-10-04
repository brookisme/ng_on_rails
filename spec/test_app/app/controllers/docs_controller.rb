class DocsController < ApplicationController
  before_action :set_doc, only: [:show, :edit, :update, :destroy]

  def index
    @docs = Doc.all
  end

  def show
  end

  def new
    @doc = Doc.new
  end

  def edit
  end

  def create
    @doc = Doc.new(doc_params)
    respond_to do |format|
      if @doc.save
        format.html { redirect_to @doc, notice: 'Doc was successfully created.' }
        format.json { render action: 'show', status: :created, location: @doc }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    unless @new_pages.blank?
      @doc.pages |= @new_pages
    end
    respond_to do |format|
      if @doc.update_attributes(doc_params)
        format.html { redirect_to @doc, notice: 'Doc was successfully updated.' }
        format.json { render action: 'show', status: :created, location: @doc }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @doc.destroy
    respond_to do |format|
      format.html { redirect_to docs_url, notice: 'Doc was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

private

  def set_doc
    @doc = Doc.find(params[:id])
  end

  def doc_params
    params.require(:doc).permit(
      :id,
      :_destroy,
      :name,
      :description
    )
  end
end
