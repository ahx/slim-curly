module Slim::Curly
  class Parser < Slim::Parser

    CURLY_TEXT_RE = /\A\s*({{.*}})/

    def parse_line_indicators
      case @line
      when CURLY_TEXT_RE
        # Found a curly text node
        @stacks.last << [:slim, :interpolate, @line]
      else
        super
      end
      @stacks.last << [:newline]
    end

    # This method is an almost 1:1 copy of Slim::Parser#parse_attributes ! Modified sections are wrapped with comments.
    # FIXME Find a DRY way to hook into the parser.
    def parse_attributes
      attributes = [:html, :attrs]

      # Find any shortcut attributes
      while @line =~ @attr_shortcut_re
        # The class/id attribute is :static instead of :slim :interpolate,
        # because we don't want text interpolation in .class or #id shortcut
        attributes << [:html, :attr, @attr_shortcut[$1], [:static, $2]]
        @line = $'
      end

      # Check to see if there is a delimiter right after the tag name
      delimiter = nil
      if @line =~ DELIM_RE
        delimiter = DELIMS[$&]
        @line.slice!(0)
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
          attributes << [:slim, :interpolate, escape, value]
        else
          break unless delimiter

          case @line
          when boolean_attr_re
            # Boolean attribute
            @line = $'
            attributes << [:html, :attr, $1, [:slim, :attrvalue, false, 'true']]

          ################ BEGIN Code different from Slim::Parser
          when CURLY_TEXT_RE
            # Find a curly
            @line = $'
            attributes << [:slim_curly, :attr, [:slim, :interpolate, $1]]
          ################ END Code different from Slim::Parser

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

      attributes
    end

  end
end
