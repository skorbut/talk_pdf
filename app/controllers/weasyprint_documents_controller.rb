class WeasyprintDocumentsController < ApplicationController
  def new
    @weasyprint_document = WeasyprintDocument.new
  end

  def edit
    @weasyprint_document = WeasyprintDocument.find(params[:id])
  end

  def show
    @weasyprint_document = WeasyprintDocument.find(params[:id])
  end

  def create
    # parse attributes from json to hash
    if weasyprint_document_params[:variables].present?
      weasyprint_document_params[:variables] = JSON.parse(weasyprint_document_params[:variables])
    end
    @weasyprint_document = WeasyprintDocument.new(weasyprint_document_params)

    if @weasyprint_document.save
      @weasyprint_document.generate_pdf
      redirect_to @weasyprint_document
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @weasyprint_document = WeasyprintDocument.find(params[:id])
    # parse attributes from json to hash
    if weasyprint_document_params[:variables].present?
      weasyprint_document_params[:variables] = JSON.parse(weasyprint_document_params[:variables])
    end

    if @weasyprint_document.update(weasyprint_document_params)
      @weasyprint_document.generate_pdf
      redirect_to @weasyprint_document
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def index
    @weasyprint_documents = WeasyprintDocument.all
  end

  def destroy
    @weasyprint_document = WeasyprintDocument.find(params[:id])
    @weasyprint_document.destroy
    redirect_to weasyprint_documents_url
  end

  private

  def weasyprint_document_params
    params.require(:weasyprint_document).permit!
  end
end