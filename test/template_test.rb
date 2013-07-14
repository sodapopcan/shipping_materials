require File.expand_path('../header', __FILE__)

class TemplateTest < UnitTest
  def test_template_render_and_concatination
    tpl_str = ''
    tpl = ShippingMaterials::Template.new
    tpl.template = '{{ name }}{{ line_items.first.id }}'
    tpl.object = orders[0]
    tpl_str << tpl.render
    tpl.object = orders[1]
    tpl_str << tpl.render


    assert_equal 'Andrew1Julie3', tpl_str,
      "Templates are not rendering properly"
  end
end
