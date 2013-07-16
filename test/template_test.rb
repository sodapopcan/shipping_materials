require File.expand_path('../header', __FILE__)

class TemplateTest < UnitTest
  def setup
		ShippingMaterials::Config.save_path './test/files'
    @tpl = ShippingMaterials::Template.new(orders.slice(0,2), 'test')
    @tpl.template_file = 'test/template.mustache'
    @tpl.layout_file = 'test/layout.mustache'
  end

  def test_layout_file_setter
    assert_equal '<html><body></body></html>', @tpl.header + @tpl.footer,
      "Template header and footer not properly being set"
  end

  def test_template_render_and_concatination
    @tpl.render!

    assert_equal "<html><body>Andrew1\nJulie3\n</body></html>", @tpl.to_s,
      "Templates are not rendering properly"
  end

  def test_to_pdf
    @tpl.render!
    @tpl.to_pdf
  end
end
