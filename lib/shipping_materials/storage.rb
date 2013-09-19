module ShippingMaterials
  class Storage
    class << self
      def write_file(filename, contents)
        filename = "#{save_path}/#{filename}"
        File.open(filename, 'w') do |fp|
          fp.write(contents)
          if Config.use_s3? && !Config.use_gzip?
            @s3 ||= S3.new
            @s3.write(filename, fp)
            File.unlink(fp)
          end
        end
      end
      alias_method :write_html, :write_file

      def write_pdf(filename, contents)
        basename = filenameize(File.basename(filename, '.*'))
        base = "#{save_path}/#{basename}"
        html_file, pdf_file = base + '.html', base + '.pdf'
        File.open(html_file, 'w') {|f| f.write(contents) }
        %x( wkhtmltopdf #{html_file} #{pdf_file} )
        File.unlink(html_file)
        if Config.use_s3? && !Config.use_gzip?
          @s3 ||= S3.new
          File.open(pdf_file) do |fp|
            @s3.write(File.basename(pdf_file), fp)
          end
          File.unlink(pdf_file)
        end
      end

      def write_gzip
        filename = "#{Config.save_path}/#{Config.gzip_file_name}"
        `cd #{Config.save_path} && tar -cvzf #{filename} * && cd -`
        if Config.use_s3?
          @s3 ||= S3.new
          File.open(filename) do |fp|
            puts "Saving gzip file to S3"
            @s3.write(Config.gzip_file_name, fp)
            puts "Done"
          end
          FileUtils.rm_rf(self.save_path) unless self.save_path == '/'
          puts "Removed working dir: #{Config.save_path}/"
        end
      end

      def save_path
        unless Dir.exists?(Config.save_path)
          FileUtils.mkdir(Config.save_path) 
          puts "Created working dir: #{Config.save_path}/"
        end
        Config.save_path
      end

      def filenameize(string)
        string.gsub(/[^A-Z0-9_]+/i, '')
      end
    end
  end
end