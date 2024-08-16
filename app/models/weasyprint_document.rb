class WeasyprintDocument < ApplicationRecord
  has_one_attached :example_pdf

  serialize :variables, coder: YAML

  def command
    'weasyprint - -'
  end

  def generate_pdf
    # process template
    content = ERB.new(self.template).result(binding)
    # render pdf
    data, _status = Open3.capture2(command, stdin_data: content)
    # attach
    example_pdf.attach(io: StringIO.new(data), filename: 'example.pdf', content_type: 'application/pdf')
  end
end
