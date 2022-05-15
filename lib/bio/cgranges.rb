# frozen_string_literal: true

require_relative "cgranges/version"
require_relative "cgranges/cgranges"

module Bio
  # Reader for .2bit files (i.e., from UCSC genome browser)
  class CGRanges
    # Calculate breadth of coverage.
    # This is a wrapper method for `coverage_overlap` and `coverage_contain`.
    # @param [String] contig The contig name
    # @param [Fixnum] start The start position of the interval.
    # @param [Fixnum] end The end position of the interval.
    # @param [Symbol] mode :overlap or :contain (default: :overlap)
    # @return [Array] The breadth of coverage and the number of intervals.
    # @see coverage_overlap
    # @see coverage_contain

    def coverage(ctg, rb_st, rb_en, mode: :overlap)
      case mode
      when :overlap
        coverage_overlap(ctg, rb_st, rb_en)
      when :contain
        coverage_contain(ctg, rb_st, rb_en)
      else
        raise ArgumentError, "unknown mode: #{mode}"
      end
    end
  end
end
