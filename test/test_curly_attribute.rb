require 'helper'

class TestSlimCurlyAttribute < TestSlim

  def test_curly_text_in_attribute_space
    source = %q{
p(id="say" {{action some}} {{append thing}} class="greet") = hello_world
}

    assert_html '<p id="say" {{action some}} {{append thing}} class="greet" >Hello World from @env</p>', source
  end

  def test_curly_text_in_attribute_space2
    source = %q{
p({{action some}} id="say" class="greet" {{append thing}}) = hello_world
}

    assert_html '<p id="say" {{action some}} {{append thing}} class="greet" >Hello World from @env</p>', source
  end

  def test_curly_text_with_interpolation_in_attribute_space
    source = %q{
p(id="say" {{action "count" #{41+1} }}) = hello_world
}

    assert_html '<p id="say" {{action "count" 42 }} >Hello World from @env</p>', source
  end

  def test_curly_text_in_attribute_space_with_delimeter
    source = %q{
p{id="say" {{something}} {{view some}} class="greet" }= hello_world
}

    assert_html '<p id="say" {{something}} {{view some}} class="greet" >Hello World from @env</p>', source
  end

  def test_curly_text_with_interpolation_in_attribute_space
    source = %q{
p id="say" {{view #{41+1} }} = hello_world
}

    assert_html '<p id="say" {{view 42 }} >Hello World from @env</p>', source
  end

  # This just worked without modifying Slim
  def test_curly_text_in_attribute_value
    source = %q{
p id="{{hello world}}"= hello_world
}

    assert_html '<p id="{{hello world}}">Hello World from @env</p>', source
  end

  # This just worked without modifying Slim
  def test_nested_interpolation_in_attribute
    source = %q{
p id="{{hello #{ "world" }}}" = hello_world
}

    assert_html '<p id="{{hello world}}">Hello World from @env</p>', source
  end

end
