class SablonDocumentsController < ApplicationController
  def new
    @sablon_document = SablonDocument.new
  end

  def edit
    @sablon_document = SablonDocument.find(params[:id])
  end

  def show
    @sablon_document = SablonDocument.find(params[:id])
  end

  def create
    @sablon_document = SablonDocument.new(sablon_document_params)

    if @sablon_document.save
      @sablon_document.extract_variables
      redirect_to @sablon_document
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @sablon_document = SablonDocument.find(params[:id])
    # only store the variables changes
    variables = sablon_document_params[:variables].to_h
    @sablon_document.variables = variables
    Rails.logger.info("variables is: #{variables}, class is #{variables.class}")
    if @sablon_document.save
      @sablon_document.generate_pdf
      redirect_to @sablon_document
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def index
    @sablon_documents = SablonDocument.all
  end

  def destroy
    @sablon_document = SablonDocument.find(params[:id])
    @sablon_document.destroy
    redirect_to sablon_documents_url
  end

  private

  def sablon_document_params
    params.require(:sablon_document).permit!
  end
end

