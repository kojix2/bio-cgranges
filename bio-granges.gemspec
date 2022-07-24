# frozen_string_literal: true

require_relative "lib/bio/cgranges/version"

Gem::Specification.new do |spec|
  spec.name          = "bio-cgranges"
  spec.version       = Bio::CGRanges::VERSION
  spec.authors       = ["kojix2"]
  spec.email         = ["2xijok@gmail.com"]

  spec.summary       = "Ruby bindings for lh3/cgranges"
  spec.description   = "Genomic interval overlap queries"
  spec.homepage      = "https://github.com/kojix2/bio-cgranges"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.files         = Dir[
                         "*.{txt,md}", "Rakefile", "lib/**/*.rb",
                         "ext/bio/cgranges/*.{c,h}",
                         "ext/bio/cgranges/extconf.rb",
                         "ext/bio/cgranges/cgranges/LICENSE.txt",
                         "ext/bio/cgranges/cgranges/README.md",
                         "ext/bio/cgranges/cgranges/cgranges.{c,h}",
                         "ext/bio/cgranges/cgranges/khash.h",
                        ]

  spec.require_paths = ["lib"]
  spec.extensions    = ["ext/bio/cgranges/extconf.rb"]
end
