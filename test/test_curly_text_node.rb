require File.expand_path('../helper', __FILE__)

class TestSlimCurlyTextNode < TestSlim

  def test_curly_text_nodes
    source = %q{
p
 {{hello}} {{bello}}
}

    assert_html '<p>{{hello}} {{bello}}</p>', source
  end

  def test_curly_text_nodes_inline
    source = %q{
p {{hello}} {{bello}}
}

    assert_html '<p>{{hello}} {{bello}}</p>', source
  end

  def test_curly_text_nodes_inline_with_text_between
    source = %q{
p {{hello}} = {{bello}}
p {{hello}} - {{bello}}
}

    assert_html '<p>{{hello}} = {{bello}}</p><p>{{hello}} - {{bello}}</p>', source
  end

  def test_curly_text_node_in_context
    source = %q{
h1 Greeting
p
 {{hello}}
 b World
}

    assert_html '<h1>Greeting</h1><p>{{hello}}<b>World</b></p>', source
  end

  def test_interpolation_in_text
    source = %q{
p
 {{say "#{hello_world}"}}
}

    assert_html '<p>{{say "Hello World from @env"}}</p>', source
  end

end
