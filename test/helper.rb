# encoding: utf-8

require 'minitest/unit'
require 'slim'
require 'slim/curly'
require 'slim/grammar'

MiniTest::Unit.autorun

# TODO Make these validate or add a custom Slim::Curly::Grammar
# Slim::Engine.after  Slim::Curly::Parser, Temple::Filters::Validator, :grammar => Slim::Grammar
# Slim::Engine.before :Pretty, Temple::Filters::Validator

class TestSlim < MiniTest::Unit::TestCase
  def setup
    @env = Env.new
  end

  def render(source, options = {}, &block)
    scope = options.delete(:scope)
    locals = options.delete(:locals)
    Slim::Template.new(options[:file], options) { source }.render(scope || @env, locals, &block)
  end

  def assert_html(expected, source, options = {}, &block)
    assert_equal expected, render(source, options, &block)
  end

  def assert_syntax_error(message, source, options = {})
    render(source, options)
    raise 'Syntax error expected'
  rescue Slim::Parser::SyntaxError => ex
    assert_equal message, ex.message
  end

  def assert_ruby_error(error, from, source, options = {})
    render(source, options)
    raise 'Ruby error expected'
  rescue error => ex
    assert_backtrace(ex, from)
  end

  def assert_backtrace(ex, from)
    if defined?(RUBY_ENGINE) && RUBY_ENGINE == 'rbx'
      # HACK: Rubinius stack trace sometimes has one entry more
      if ex.backtrace[0] !~ /^#{Regexp.escape from}:/
        ex.backtrace[1] =~ /^(.*?:\d+):/
        assert_equal from, $1
      end
    else
      ex.backtrace[0] =~ /^(.*?:\d+):/
      assert_equal from, $1
    end
  end

  def assert_ruby_syntax_error(from, source, options = {})
    render(source, options)
    raise 'Ruby syntax error expected'
  rescue SyntaxError => ex
    ex.message =~ /^(.*?:\d+):/
    assert_equal from, $1
  end

  def assert_runtime_error(message, source, options = {})
    render(source, options)
    raise Exception, 'Runtime error expected'
  rescue RuntimeError => ex
    assert_equal message, ex.message
  end
end

class Env
  def hello_world(text = "Hello World from @env", opts = {})
    text << opts.to_a * " " if opts.any?
    if block_given?
      "#{text} #{yield} #{text}"
    else
      text
    end
  end
end
