require File.expand_path('../header', __FILE__)

class TemplateTest < UnitTest
  def test_template_render_and_concatination
    tpl = ShippingMaterials::Template.new(orders.slice(0,2))
    tpl.template_file = 'test/template.mustache'
    tpl.package

    assert_equal "Andrew1\nJulie3\n", tpl.to_s,
      "Templates are not rendering properly"
  end
end
