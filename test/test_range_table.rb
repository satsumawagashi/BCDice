# frozen_string_literal: true

require "test/unit"
require "bcdice/dice_table/range_table"

class TestRangeTable < Test::Unit::TestCase
  # ダイスロール方法の書式が正しい場合、受理される
  def test_valid_dice_roll_method_should_be_accepted_1
    assert_nothing_raised do
      BCDice::DiceTable::RangeTable.new(
        "Table",
        "2D6",
        [
          [2..7,  "A"],
          [8..12, "B"],
        ]
      )
    end
  end

  # ダイスロール方法の書式が正しい場合、受理される
  def test_valid_dice_roll_method_should_be_accepted_2
    assert_nothing_raised do
      BCDice::DiceTable::RangeTable.new(
        "Table",
        "1D100",
        [
          [1..25,   "A"],
          [26..50,  "B"],
          [51..75,  "C"],
          [76..100, "D"],
        ]
      )
    end
  end

  # ダイスロール方法の書式が正しい場合、受理される
  def test_valid_dice_roll_method_should_be_accepted_3
    assert_nothing_raised do
      BCDice::DiceTable::RangeTable.new(
        "Table",
        "2D6",
        [
          [2..6,  "A"],
          [7,     "B"],
          [8..11, "C"],
          [12,    "D"],
        ]
      )
    end
  end

  # ダイスロール方法の書式が正しい場合、受理される
  def test_valid_dice_roll_method_should_be_accepted_4
    assert_nothing_raised do
      BCDice::DiceTable::RangeTable.new(
        "Table",
        "2D6",
        [
          [2...8,  "A"],
          [8...13, "B"],
        ]
      )
    end
  end

  # ダイスロール方法の書式が正しくない場合、拒絶される
  def test_invalid_dice_roll_method_should_be_denied_1
    assert_raise(ArgumentError) do
      BCDice::DiceTable::RangeTable.new(
        "Table",
        "D6",
        [
          [1..3, "A"],
          [4..6, "B"],
        ]
      )
    end
  end

  # ダイスロール方法の書式が正しくない場合、拒絶される
  def test_invalid_dice_roll_method_should_be_denied_2
    assert_raise(ArgumentError) do
      BCDice::DiceTable::RangeTable.new(
        "Table",
        "2B6",
        [
          [2..7,  "A"],
          [8..12, "B"],
        ]
      )
    end
  end

  # 範囲の型が正しくなかった場合、拒絶される
  def test_invalid_typed_range_should_be_denied
    assert_raise(TypeError) do
      BCDice::DiceTable::RangeTable.new(
        "Table",
        "2D6",
        [
          [2.0..3, "A"],
          [4..6.0, "B"],
          [7.0,    "C"],
          [8..12,  "D"],
        ]
      )
    end
  end

  # カバーしきれていない出目の合計値の範囲がある場合、拒絶される
  def test_range_gap_should_be_denied_1
    assert_raise(RangeError) do
      BCDice::DiceTable::RangeTable.new(
        "Table",
        "2D6",
        [
          [2..7,  "A"],
          [9..12, "B"],
        ]
      )
    end
  end

  # カバーしきれていない出目の合計値の範囲がある場合、拒絶される
  def test_range_gap_should_be_denied_2
    assert_raise(RangeError) do
      BCDice::DiceTable::RangeTable.new(
        "Table",
        "2D6",
        [
          [2...7, "A"],
          [8..12, "B"],
        ]
      )
    end
  end

  # 出目の合計値の範囲が重なっている場合、拒絶される
  def test_range_overlap_should_be_denied
    assert_raise(RangeError) do
      BCDice::DiceTable::RangeTable.new(
        "Table",
        "2D6",
        [
          [2..7,  "A"],
          [7..12, "B"],
        ]
      )
    end
  end

  def test_valid_conv_string_range_should_be_accepted
    assert_equal(
      2,
      BCDice::DiceTable::RangeTable.conv_string_range(2)
    )
    assert_equal(
      Range.new(3, 7),
      BCDice::DiceTable::RangeTable.conv_string_range("3..7")
    )
    assert_equal(
      8,
      BCDice::DiceTable::RangeTable.conv_string_range("8")
    )
  end

  def test_invalid_conv_string_range_should_be_denied
    assert_raise(ArgumentError) do
      BCDice::DiceTable::RangeTable.conv_string_range("2..X")
    end
    assert_raise(ArgumentError) do
      BCDice::DiceTable::RangeTable.conv_string_range("hoge")
    end
    assert_raise(TypeError) do
      BCDice::DiceTable::RangeTable.conv_string_range([])
    end
  end
end
