# frozen_string_literal: true

require "test_helper"

class CGRangesTest < Test::Unit::TestCase
  def test_version
    assert_true Bio::CGRanges.const_defined?(:VERSION)
  end

  def test_initialize
    cgranges = Bio::CGRanges.new
    assert_instance_of Bio::CGRanges, cgranges
  end

  def test_add
    cgranges = Bio::CGRanges.new
    assert_nothing_raised do
      cgranges.add("chr1", 10, 20, 0)
      cgranges.add("chr1", 15, 25, 1)
    end
  end

  def test_index
    cgranges = Bio::CGRanges.new
    assert_nothing_raised do
      cgranges.add("chr1", 10, 20, 0)
      cgranges.add("chr1", 15, 25, 1)
      cgranges.index
    end
  end
end
