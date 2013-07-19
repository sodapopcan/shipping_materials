module ShippingMaterials
  class FileUtils
    class << self
      def write_file(filename, contents)
        filename = "#{Config.save_path}/#{filename}"
        File.open(filename, 'w') {|f| f.write(contents) } 
      end

      def write_pdf(filename, contents)
        basename = File.basename(filename, '.*')
        base = "#{Config.save_path}/#{basename}"
        html_file, pdf_file = base + '.html', base + '.pdf'
        File.open(html_file, 'w') {|f| f.write(contents) }
        %x( wkhtmltopdf #{html_file} #{pdf_file} )
        File.unlink(html_file)
      end
    end
  end
end