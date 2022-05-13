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
    r = []
    assert_nothing_raised do
      r << cgranges.add("chr1", 10, 20, 0)
      r << cgranges.add("chr2", 15, 25, 1)
    end
    assert_true(r.all? { |x| x.is_a?(Bio::CGRanges) })
  end

  def test_add_indexed_cgranges
    cgranges = Bio::CGRanges.new
    cgranges.index
    assert_raises(Bio::CGRanges::IndexedError) do
      cgranges.add("chr1", 10, 20, 0)
    end
  end

  def test_index
    cgranges = Bio::CGRanges.new
    r = nil
    assert_nothing_raised do
      cgranges.add("chr1", 10, 20, 0)
      cgranges.add("chr1", 15, 25, 1)
      r = cgranges.index
    end
    assert_instance_of Bio::CGRanges, r
  end

  def test_index_already_indexed
    cgranges = Bio::CGRanges.new
    cgranges.index
    assert_raises(Bio::CGRanges::IndexedError) do
      cgranges.index
    end
  end

  def test_overlap
    cgranges = Bio::CGRanges.new
    cgranges.add("chr1", 10, 20, 0)
    cgranges.add("chr1", 15, 25, 1)
    cgranges.add("chr1", 30, 40, 2)
    cgranges.add("chr1", 10, 25, 3)
    cgranges.add("chr1", 15, 20, 4)
    cgranges.add("chr2", 10, 20, 5)
    cgranges.index
    act = cgranges.overlap("chr1", 12, 22)
    exp = [["chr1", 10, 20, 0],
           ["chr1", 10, 25, 3],
           ["chr1", 15, 25, 1],
           ["chr1", 15, 20, 4]]
    assert_equal exp, act
  end

  def test_overlap_method_chain
    granges = Bio::CGRanges.new
    act = granges
          .add("chr1", 10, 20, 0)
          .add("chr1", 15, 25, 1)
          .add("chr1", 30, 40, 2)
          .add("chr1", 10, 25, 3)
          .add("chr1", 15, 20, 4)
          .add("chr2", 10, 20, 5)
          .index
          .overlap("chr1", 12, 22)
    exp = [["chr1", 10, 20, 0],
           ["chr1", 10, 25, 3],
           ["chr1", 15, 25, 1],
           ["chr1", 15, 20, 4]]
    assert_equal exp, act
  end

  def test_overlap_without_index
    cgranges = Bio::CGRanges.new
    cgranges.add("chr1", 10, 20, 0)
    cgranges.add("chr1", 15, 25, 1)
    assert_raises(Bio::CGRanges::NoIndexError) do
      cgranges.overlap("chr1", 12, 22)
    end
  end

  def test_contain
    cgranges = Bio::CGRanges.new
    cgranges.add("chr1", 10, 20, 0)
    cgranges.add("chr1", 15, 25, 1)
    cgranges.add("chr1", 20, 30, 2)
    cgranges.add("chr1", 10, 25, 3)
    cgranges.add("chr1", 15, 20, 4)
    cgranges.add("chr2", 10, 20, 5)
    cgranges.index
    act = cgranges.contain("chr1", 12, 22)
    exp = [["chr1", 15, 20, 4]]
    assert_equal exp, act
  end

  def test_contain_method_chain
    granges = Bio::CGRanges.new
    act = granges
          .add("chr1", 10, 20, 0)
          .add("chr1", 15, 25, 1)
          .add("chr1", 20, 30, 2)
          .add("chr1", 10, 25, 3)
          .add("chr1", 15, 20, 4)
          .add("chr2", 10, 20, 5)
          .index
          .contain("chr1", 12, 22)
    exp = [["chr1", 15, 20, 4]]
    assert_equal exp, act
  end

  def test_contain_without_index
    cgranges = Bio::CGRanges.new
    cgranges.add("chr1", 10, 20, 0)
    cgranges.add("chr1", 15, 25, 1)
    assert_raises(Bio::CGRanges::NoIndexError) do
      cgranges.contain("chr1", 12, 22)
    end
  end

  def test_count_overlap
    cgranges = Bio::CGRanges.new
    cgranges.add("chr1", 10, 20, 0)
    cgranges.add("chr1", 15, 25, 1)
    cgranges.add("chr1", 30, 40, 2)
    cgranges.add("chr1", 10, 25, 3)
    cgranges.add("chr1", 15, 20, 4)
    cgranges.add("chr2", 10, 20, 5)
    cgranges.index
    act = cgranges.count_overlap("chr1", 12, 22)
    exp = 4
    assert_equal exp, act
  end

  def test_count_contain
    cgranges = Bio::CGRanges.new
    cgranges.add("chr1", 10, 20, 0)
    cgranges.add("chr1", 15, 25, 1)
    cgranges.add("chr1", 20, 30, 2)
    cgranges.add("chr1", 10, 25, 3)
    cgranges.add("chr1", 15, 20, 4)
    cgranges.add("chr2", 10, 20, 5)
    cgranges.index
    act = cgranges.count_contain("chr1", 12, 22)
    exp = 1
    assert_equal exp, act
  end
end