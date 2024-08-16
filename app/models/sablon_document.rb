class SablonDocument < ApplicationRecord
  has_one_attached :example_pdf
  has_one_attached :template

  serialize :variables, coder: YAML

  def generate_pdf
    return unless sablon_template

    # convert to document docx
    converted_docx = Tempfile.new('converted.docx')

    sablon_template.render_to_file(converted_docx.path, variables || {})

    converted_docx.rewind

    converted_pdf = Tempfile.new('converted.pdf')

    soffice_command = "/Applications/LibreOffice.app/Contents/MacOS/soffice"

    # convert to pdf
    Libreconv.convert(converted_docx.path, converted_pdf.path, soffice_command)

    converted_pdf.rewind
    example_pdf.attach(io: converted_pdf, filename: 'example.pdf', content_type: 'application/pdf')
  end

  def extract_variables
    template_file = download_template

    model = Sablon::DOM::Model.new(Zip::File.open(template_file.path, !File.exist?(template_file.path)))
    content = model.zip_contents["word/document.xml"]

    parser = Sablon::Parser::MailMerge.new
    variable_names = parser.parse_fields(content).map(&:expression).uniq.map {|expr| expr[1..-1].to_sym}
    self.variables ||= {}
    variable_names.each {|name| self.variables[name] ||= "" }
    save!

  end

  def sablon_template
    @sablon_template ||= load_sablon_template
  end

  def load_sablon_template
    return unless template.attached?
    # download template to Tempfile

    Sablon.template(download_template.path)
  end

  def download_template
    template_file = Tempfile.new('template.docx')
    template_file.binmode
    template_file.write(template.download)
    template_file.rewind
    template_file
  end
end
