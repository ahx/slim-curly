require 'helper'

class TestSlimCurlyTextNode < TestSlim

  def test_curly_text_node
    source = %q{
p
 {{hello}}
}

    assert_html '<p>{{hello}}</p>', source
  end

  def test_curly_text_node_inline
    source = %q{
p {{hello}}
}

    assert_html '<p>{{hello}}</p>', source
  end

  def test_curly_text_node_with_helper
    source = %q{
p
 {{hello world}}
}

    assert_html '<p>{{hello world}}</p>', source
  end

  def test_interpolation_in_text
    source = %q{
p
 {{say "#{hello_world}"}}
}

    assert_html '<p>{{say "Hello World from @env"}}</p>', source
  end


end
