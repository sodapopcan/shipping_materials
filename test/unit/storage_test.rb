require 'test_helper'

module ShippingMaterials
  class StorageTest < TestCase
    def setup
      @filename = 'hello_world'
      @content  = 'Hello Mr. World'
    end

    def test_write_file
      filename = @filename + '.txt'

      ShippingMaterials::Storage.write_file(filename, @content)

      full_path = "#{ShippingMaterials::Config.save_path}/#{filename}"
      assert File.exists?(full_path), "File did not get saved"

      if File.exists?(full_path)
        assert_equal @content, File.read(full_path),
          "File contents were not properly written"

        File.unlink(full_path)
      end
    end

    def test_write_pdf
      filename = @filename + '.pdf'

      ShippingMaterials::Storage.write_pdf(filename, @content)

      full_path = "#{ShippingMaterials::Config.save_path}/#{filename}"
      assert File.exists?(full_path), "PDF did not get saved"

      File.unlink(full_path) if File.exists?(full_path)
    end
  end
end