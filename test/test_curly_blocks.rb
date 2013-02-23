require File.expand_path('../helper', __FILE__)

class TestSlimCurlyBlocks < TestSlim

  def block_indicators
    %w(# ^)
  end

  def test_close_curly_blocks_with_different_block_indicators
    block_indicators.each do |block_indicator|
      source = %q{
p
  {{#nuts}}
    b Foo
}

    assert_html '<p>{{#nuts}}<b>Foo</b>{{/nuts}}</p>', source
    end
  end


  def test_close_curly_blocks_with_interpolation
    block_indicators.each do |block_indicator|
      source = %q{
p
  {{##{"model#{1+2}"}}}
    b Foo
}

    assert_html '<p>{{#model3}}<b>Foo</b>{{/model3}}</p>', source
    end
  end

end
