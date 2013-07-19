module ShippingMaterials
  class FileUtils
    class << self
      def write_file(filename, contents)
        filename = "#{Config.save_path}/#{filename}"
        File.open(filename, 'w') {|f| f.write(contents) } 
      end

      def write_pdf(filename, contents)
        base = "#{Config.save_path}/#{filename}"
        html_file, pdf_file = base + '.html', base + '.pdf'
        File.open(html, 'w') {|f| f.write(contents) }
        %x( wkhtmltopdf #{html} #{pdf} )
        File.unlink(html_file)
      end
    end
  end
end