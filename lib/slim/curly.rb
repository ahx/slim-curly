require "slim"
require "slim/curly/version"
require "slim/curly/parser"

# Reopen an modify the slim engine!
class Slim::Engine
  replace Slim::Parser, Slim::Curly::Parser
end
