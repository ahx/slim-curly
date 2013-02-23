module Slim::Curly
  class Parser < Slim::Parser
    OCURLY = '{{'
    CCURLY = '}}'
    # CURLY_BLOCK_INDICATORS = ['#', '^']

    # Same as Slim::Parser::ATTR_DELIM_RE, but different.
    # This matches "{{{..." and "{...", but not "{{..."
    ATTR_DELIM_RE = /\A\s*([#{Regexp.escape DELIMS.keys.join}])(?!{[^{])/

    def parse_line_indicators
      case @line
      when /\A#{OCURLY}/
        # TODO Handle blocks.
        # Found a curly text node
        @stacks.last << [:slim, :interpolate, @line]
        @stacks.last << [:newline]
        # TODO call syntax_error! if there is no closing }}
      else
        super
      end
    end

    # NOTE: Most code of this method method is copied from Slim::Parser#parse_attributes (FIXME Don't copy Slim::Parser#parse_attributes)
    def parse_attributes
      attributes = []
      curly_attributes = []

      # Find any shortcut attributes
      while @line =~ @attr_shortcut_re
        # The class/id attribute is :static instead of :slim :interpolate,
        # because we don't want text interpolation in .class or #id shortcut
        attributes << [:html, :attr, @attr_shortcut[$1], [:static, $2]]
        @line = $'
      end

      # Check to see if there is a delimiter right after the tag name
      delimiter = nil
      if @line =~ ATTR_DELIM_RE
        delimiter = DELIMS[$1]
        @line = $'
      end

      if delimiter
        boolean_attr_re = /#{ATTR_NAME}(?=(\s|#{Regexp.escape delimiter}|\Z))/
        end_re = /\A\s*#{Regexp.escape delimiter}/
      end

      while true
        case @line
        when /\A\s*\*(?=[^\s]+)/
          # Splat attribute
          @line = $'
          attributes << [:slim, :splat, parse_ruby_code(delimiter)]
        when QUOTED_ATTR_RE
          # Value is quoted (static)
          @line = $'
          attributes << [:html, :attr, $1,
                         [:escape, $2.empty?, [:slim, :interpolate, parse_quoted_attribute($3)]]]
        when CODE_ATTR_RE
          # Value is ruby code
          @line = $'
          name = $1
          escape = $2.empty?
          value = parse_ruby_code(delimiter)
          syntax_error!('Invalid empty attribute') if value.empty?
          attributes << [:html, :attr, name, [:slim, :attrvalue, escape, value]]

          #### BEGIN Code differrent from Slim::Parser
        when /\A\s*(#{OCURLY})/
          # Found a curly standalone attribute
          break unless delimiter
          @line = $'
          # Prepend a space before the attribute.
          attribute = ' ' + parse_curly_value($1)
          curly_attributes << [:slim, :interpolate, attribute]
          #### END Code differrent from Slim::Parser
        else
          break unless delimiter

          case @line

          when boolean_attr_re
            # Boolean attribute
            @line = $'
            attributes << [:html, :attr, $1, [:slim, :attrvalue, false, 'true']]
          when end_re
            # Find ending delimiter
            @line = $'
            break
          else
            # Found something where an attribute should be
            @line.lstrip!
            syntax_error!('Expected attribute') unless @line.empty?

            # Attributes span multiple lines
            @stacks.last << [:newline]
            syntax_error!("Expected closing delimiter #{delimiter}") if @lines.empty?
            next_line
          end
        end
      end

      #### BEGIN Code differrent from Slim::Parser
      [:multi, [:html, :attrs] + attributes, *curly_attributes]
      #### END Code differrent from Slim::Parser
    end

    private

    # Parses text wrapped in curly ("{{....}}") and forwards the @line pointer right after the closing delimiter }}
    def parse_curly_value(ocurly)
      value = ocurly
      if @line =~ /#\{/
        # Interpolation found
        if @line =~ /\A.*?}/
          value << $&
          @line = $'
        end
      end
      if @line =~ /(#{CCURLY})/
        value << $`
        value << $1
        @line = $'
      end
      value
    end

  end
end
