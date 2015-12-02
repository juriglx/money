require 'minitest/autorun'
require 'money'

class MoneyTest < Minitest::Test
  def test_assignment
    fifty_eur = Money.new(50, 'EUR')

    assert_equal 50, fifty_eur.amount
    assert_equal 'EUR', fifty_eur.currency
  end

  def test_inspect
    fifty_eur = Money.new(50, 'EUR')

    assert_equal "50.00 EUR", fifty_eur.inspect
  end

  def test_conversion_base_to_other
    Money.conversion_rates('EUR', {
      'USD' => 1.11
    })
    fifty_eur = Money.new(50, 'EUR')

    dollars = fifty_eur.convert_to('USD')

    assert_equal 55.50, dollars.amount
    assert_equal 'USD', dollars.currency
  end

  def test_conversion_other_to_base
    Money.conversion_rates('EUR', {
      'USD' => 1.11
    })
    fifty_dollars = Money.new(50, 'USD')

    euros = fifty_dollars.convert_to('EUR')

    assert_equal 45.05, euros.amount
    assert_equal 'EUR', euros.currency
  end

  def test_conversion_other_to_other
    Money.conversion_rates('EUR', {
      'USD' => 0.5,
      'Bitcoin' => 0.5
    })
    fifty_dollars = Money.new(50, 'USD')

    bitcoins = fifty_dollars.convert_to('Bitcoin')

    assert_equal 50, bitcoins.amount
    assert_equal 'Bitcoin', bitcoins.currency
  end

  def test_addition
    Money.conversion_rates('EUR', {
      'USD' => 1.11
    })
    fifty_eur = Money.new(50, 'EUR')
    twenty_dollars = Money.new(20, 'USD')

    result = fifty_eur + twenty_dollars

    assert_equal 68.02, result.amount
    assert_equal 'EUR', result.currency
  end

  def test_subtraction
    Money.conversion_rates('EUR', {
      'USD' => 1.11
    })
    fifty_eur = Money.new(50, 'EUR')
    twenty_dollars = Money.new(20, 'USD')

    result = fifty_eur - twenty_dollars

    assert_equal 31.98, result.amount
    assert_equal 'EUR', result.currency
  end

  def test_multiplication
    Money.conversion_rates('EUR', {
      'USD' => 1.11
    })
    twenty_dollars = Money.new(20, 'USD')

    result = twenty_dollars * 3

    assert_equal 60, result.amount
    assert_equal 'USD', result.currency
  end

  def test_division
    Money.conversion_rates('EUR', {
      'USD' => 1.11
    })
    fifty_eur = Money.new(50, 'EUR')

    result = fifty_eur / 2

    assert_equal 25, result.amount
    assert_equal 'EUR', result.currency
  end

  def test_equality
    Money.conversion_rates('EUR', {
      'USD' => 1.11
    })
    twenty_dollars = Money.new(20, 'USD')

    assert_equal Money.new(20, 'USD'), twenty_dollars
    refute_equal Money.new(30, 'USD'), twenty_dollars
  end

  def test_equality_with_conversion
    Money.conversion_rates('EUR', {
      'USD' => 1.11
    })
    fifty_eur = Money.new(50, 'EUR')
    fifty_eur_in_usd = fifty_eur.convert_to('USD')

    assert_equal fifty_eur, fifty_eur_in_usd
  end

  def test_comparisons
    Money.conversion_rates('EUR', {
      'USD' => 1.11
    })
    twenty_dollars = Money.new(20, 'USD')

    assert_operator twenty_dollars, :>, Money.new(5, 'USD')
    assert_operator twenty_dollars, :<, Money.new(50, 'EUR')
  end
end
