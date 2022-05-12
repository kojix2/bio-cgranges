# frozen_string_literal: true

require "test_helper"

class GRangesTest < Test::Unit::TestCase
  def test_version
    assert_true Bio::GRanges.const_defined?(:VERSION)
  end

  def test_initialize
    granges = Bio::GRanges.new
    assert_instance_of Bio::GRanges, granges
  end

  def test_add
    granges = Bio::GRanges.new
    assert_nothing_raised do
      granges.add("chr1", 10, 20, 0)
      granges.add("chr1", 15, 25, 1)
    end
  end

  def test_index
    granges = Bio::GRanges.new
    assert_nothing_raised do
      granges.add("chr1", 10, 20, 0)
      granges.add("chr1", 15, 25, 1)
      granges.index
    end
  end
end
