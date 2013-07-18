module ShippingMaterials
  class AssetUtils
		def write_asset(asset)
			filename = "#{Config.save_path}/#{asset.filename}"
			File.open(filename, 'w') {|f| f.write(asset.to_s) } 
		end

    def write_pdf(asset)
			base = "#{Config.save_path}/#{asset.basename}"
			html_file, pdf_file = base + '.html', base + '.pdf'
      File.open(html, 'w') {|f| f.write(asset.to_s) }
      %x( wkhtmltopdf #{html} #{pdf} )
			File.unlink(html_file)
    end
  end
end