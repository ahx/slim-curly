module Slim::Curly
  class Parser < Slim::Parser

    def parse_line_indicators
      case @line
      when /\A({{.*}})/
        # Found a curly text node
        @stacks.last << [:slim, :interpolate, @line]
      else
        super
      end
      @stacks.last << [:newline]
    end

    # Fishes out all curlies from the attributes at once, then pass the rest to super.
    #
    # Note that curly attributes like:
    #    a({{action go}}) Go!
    # => <a {{action go}}>Go!</a>
    # are only allowed when used inside delimiters.
    # FIXME Could this be done cleaner if Slim's attributes were
    # parsed in an extra filter, instead of inside the parser?
    def parse_attributes
      curly_attributes = [:multi]
      # Check to see if there is a delimiter right after the tag name
      delimiter = nil
      if @line =~ DELIM_RE
        delimiter = DELIMS[$&]
      end
      # TODO Do something.
      # curly_attributes << [:slim, :interpolate, $1]

      [:multi, curly_attributes, super]
    end

  end
end
