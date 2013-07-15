require File.expand_path('../header', __FILE__)

class TemplateTest < UnitTest
  def setup
    @tpl = ShippingMaterials::Template.new(orders.slice(0,2), 'filename')
    @tpl.template_file = 'test/template.mustache'
  end

  def test_template_render_and_concatination
    @tpl.package

    assert_equal "Andrew1\nJulie3\n", @tpl.to_s,
      "Templates are not rendering properly"
  end

  def test_to_pdf
    @tpl.package
    @tpl.to_pdf
  end
end
