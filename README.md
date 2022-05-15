# bio-cgranges

[![Gem Version](https://badge.fury.io/rb/bio-cgranges.svg)](https://badge.fury.io/rb/bio-cgranges)
[![test](https://github.com/ruby-on-bioc/bio-cgranges/actions/workflows/ci.yml/badge.svg)](https://github.com/ruby-on-bioc/bio-cgranges/actions/workflows/ci.yml)
[![docs](https://img.shields.io/badge/docs-stable-blue.svg)](https://rubydoc.info/gems/bio-cgranges)
[![docs](https://img.shields.io/badge/docs-latest-blue.svg)](https://ruby-on-bioc.github.io/bio-cgranges/)

Ruby bindings to [lh3/cgranges](https://github.com/lh3/cgranges).

> cgranges is a small C library for genomic interval overlap queries

## Installation

```sh
gem install bio-cgranges
```

## Usage

```ruby
require "bio/cgranges"

granges = Bio::CGRanges.new
granges.add("chr1", 10, 20, 0)
       .add("chr1", 15, 25, 1)
       .add("chr1", 30, 40, 2)
       .add("chr1", 10, 25, 3)
       .add("chr1", 15, 20, 4)
       .add("chr2", 10, 20, 5)
       .index
       
granges.overlap("chr1", 12, 22)
# [["chr1", 10, 20, 0],
#  ["chr1", 10, 25, 3],
#  ["chr1", 15, 25, 1],
#  ["chr1", 15, 20, 4]]

granges.contain("chr1", 12, 22)
# [["chr1", 15, 20, 4]]
```

```
0.........5.........10........15........20........25........30........35........40
|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|
                     0-0-0-0-0-0-0-0-0-0
                               1-1-1-1-1-1-1-1-1-1
                                                             2-2-2-2-2-2-2-2-2-2
                     3-3-3-3-3-3-3-3-3-3-3-3-3-3-3
                               4-4-4-4-4
           5-5-5-5-5
                         Q-Q-Q-Q-Q-Q-Q-Q-Q-Q
|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|
0.........5.........10........15........20........25........30........35........40
```

See [![docs](https://img.shields.io/badge/docs-latest-blue.svg)](https://ruby-on-bioc.github.io/bio-cgranges/) for details.

## Development

Bug reports and pull requests are welcome on GitHub at https://github.com/ruby-on-bioc/bio-cgranges.

    Do you need commit rights to this repository?
    Do you want to get admin rights and take over the project?
    If so, please feel free to contact us.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
