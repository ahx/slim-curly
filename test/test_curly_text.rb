require File.expand_path('../helper', __FILE__)

class TestSlimCurlyText < TestSlim

  def test_curly_text
    source = %q{
p
 {{hello}} {{bello}}
}

    assert_html '<p>{{hello}} {{bello}}</p>', source
  end

  def test_curly_text_inline
    source = %q{
p {{hello}} {{bello}}
}

    assert_html '<p>{{hello}} {{bello}}</p>', source
  end

  def test_curly_text_inline_with_class
    source = %q{
p.peng {{hello}} {{bello}}
}

    assert_html '<p class="peng">{{hello}} {{bello}}</p>', source
  end

  def test_curly_text_in_context
    source = %q{
h1 Greeting
p
 {{hello}}
 b World
}

    assert_html '<h1>Greeting</h1><p>{{hello}}<b>World</b></p>', source
  end

  def test_curly_text_with_interpolation
    source = %q{
p
 {{say "#{hello_world}"}}
}

    assert_html '<p>{{say "Hello World from @env"}}</p>', source
  end

    def test_curly_text_with_nested_interpolation
    source = %q{
p
 {{say "#{hello_world}" #{1+2}}}
}

    assert_html '<p>{{say "Hello World from @env" 3}}</p>', source
  end

end
