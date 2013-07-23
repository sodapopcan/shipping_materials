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

      def write_pdf(filename, contents)
        basename = File.basename(filename, '.*')
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

      def gzip
        filename = "#{Config.save_path}/#{Config.gzip_file_name}"
        `cd #{Config.save_path} && \
         tar -cvzf #{filename} * && \
         cd -`
        if Config.use_s3?
          @s3 ||= S3.new
          File.open(filename) do |fp|
            @s3.write(Config.gzip_file_name, fp)
          end
          FileUtils.rm_rf(self.save_path)
        end
      end

      def save_path
        FileUtils.mkdir(Config.save_path) unless Dir.exists?(Config.save_path)
        Config.save_path
      end
    end
  end
end