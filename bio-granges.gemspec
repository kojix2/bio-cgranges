# frozen_string_literal: true

require_relative "lib/bio/cgranges/version"

Gem::Specification.new do |spec|
  spec.name          = "bio-cgranges"
  spec.version       = Bio::CGRanges::VERSION
  spec.authors       = ["kojix2"]
  spec.email         = ["2xijok@gmail.com"]

  spec.summary       = "Ruby bindings for lh3/cgranges"
  spec.description   = "Genomic interval overlap queries"
  spec.homepage      = "https://github.com/ruby-on-bioc/bio-cgranges"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.require_paths = ["lib"]
  spec.extensions    = ["ext/bio/cgranges/extconf.rb"]
end
