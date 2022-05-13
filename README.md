# bio-cgranges

[![Gem Version](https://badge.fury.io/rb/bio-cgranges.svg)](https://badge.fury.io/rb/bio-cgranges)
[![test](https://github.com/ruby-on-bioc/bio-cgranges/actions/workflows/ci.yml/badge.svg)](https://github.com/ruby-on-bioc/bio-cgranges/actions/workflows/ci.yml)
[![dics](https://img.shields.io/badge/docs-stable-blue.svg)](https://rubydoc.info/gems/bio-cgranges)

Ruby bindings to [lh3/cgranges](https://github.com/lh3/cgranges).

> cgranges is a small C library for genomic interval overlap queries

## Installation

```sh
gem install bio-cgranges
```

## Usage

```ruby
cgranges.add("chr1", 10, 20, 0) # contig, start, end, label
        .add("chr1", 15, 25, 1)
        .add("chr1", 20, 30, 2)
        .add("chr1", 5,  35, 3)
        .add("chr2", 10, 20, 0)
        .add("chr2", 15, 25, 1)
        .index

p cgranges.overlap("chr1", 12, 16)
```

## Development

Bug reports and pull requests are welcome on GitHub at https://github.com/ruby-on-bioc/bio-cgranges.

    Do you need commit rights to my repository?
    Do you want to get admin rights and take over the project?
    If so, please feel free to contact us @kojix2.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
