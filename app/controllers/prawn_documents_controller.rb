class PrawnDocumentsController < ApplicationController
  def new
    @prawn_document = PrawnDocument.new
  end

  def edit
    @prawn_document = PrawnDocument.find(params[:id])
  end

  def show
    @prawn_document = PrawnDocument.find(params[:id])
  end

  def create
    @prawn_document = PrawnDocument.new(prawn_document_params)

    if @prawn_document.save
      @prawn_document.generate_pdf
      redirect_to @prawn_document
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @prawn_document = PrawnDocument.find(params[:id])
    if @prawn_document.update(prawn_document_params)
      @prawn_document.generate_pdf
      redirect_to @prawn_document
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def index
    @prawn_documents = PrawnDocument.all
  end

  private

  def prawn_document_params
    params.require(:prawn_document).permit(:title, :content, :width, :height)
  end
end
