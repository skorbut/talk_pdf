require "prawn/measurement_extensions"

class PrawnDocument < ApplicationRecord
  has_one_attached :example_pdf

  def generate_pdf
    # generate pdf
    pdf = Prawn::Document.new(page_size: page_size, margin: 0)
    eval(content)
    # attach
    example_pdf.attach(io: StringIO.new(pdf.render_file('example.pdf')), filename: 'example.pdf', content_type: 'application/pdf')
  end

  def page_size
    return [210.mm, 297.mm] if width.nil? || height.nil?
    [width.mm, height.mm]
  end
end
