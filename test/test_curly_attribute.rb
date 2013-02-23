require File.expand_path('../helper', __FILE__)

class TestSlimCurlyAttribute < TestSlim
  def test_curly_attribute
    source = %q{
p({{action some}}) = hello_world
}

    assert_html '<p {{action some}}>Hello World from @env</p>', source
  end

  def test_curly_attribute_with_padding
    source = %q{
p( {{action some}} ) = hello_world
}

    assert_html '<p {{action some}}>Hello World from @env</p>', source
  end

  def test_curly_attributes_aligned
    source = %q{
p({{action some}} {{action thing}}) = hello_world
}

    assert_html '<p {{action some}} {{action thing}}>Hello World from @env</p>', source
  end


  def test_curly_attribute_in_curly_delimiter_with_precending_space
    source = %q{
p#say{ {{something}} {{view some}} class="greet" }= hello_world
}

    assert_html '<p class="greet" id="say" {{something}} {{view some}}>Hello World from @env</p>', source
  end

  def test_curly_attribute_in_curly_delimiter_without_precending_space
    source = %q{
p#say{{{something}} {{view some}} class="greet"}= hello_world
}

    assert_html '<p class="greet" id="say" {{something}} {{view some}}>Hello World from @env</p>', source
  end

  def test_curly_attribute_with_interpolation
    source = %q{
p({{view #{41+1}}}) = hello_world
}

    assert_html '<p {{view 42}}>Hello World from @env</p>', source
  end

  def test_curly_attribute_across_two_lines
    source = %q{
p({{hello}}
  {{world}})= hello_world
}

    assert_html '<p {{hello}} {{world}}>Hello World from @env</p>', source
  end

  # NOTE: This just worked without modifying Slim
  def test_curly_in_attribute_value
    source = %q{
p id="{{hello world}}"= hello_world
}

    assert_html '<p id="{{hello world}}">Hello World from @env</p>', source
  end

  # NOTE: This just worked without modifying Slim
  def test_curly_in_attribute_value_with_interpolation
    source = %q{
p id="{{hello #{ "world" }}}" = hello_world
}

    assert_html '<p id="{{hello world}}">Hello World from @env</p>', source
  end

end
