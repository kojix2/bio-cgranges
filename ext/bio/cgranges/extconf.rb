# frozen_string_literal: true

require "mkmf"

$objs = Dir.glob(["{.,cgranges}/*.c"], base: __dir__)
           .map { |f| File.expand_path(f, __dir__) }
           .map { |f| f.sub(/\.c$/, ".o") }

create_makefile("bio/cgranges/cgranges")
