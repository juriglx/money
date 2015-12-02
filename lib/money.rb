class Money
  include Comparable
  attr_reader :amount, :currency

  def initialize(amount, currency)
    @amount = amount
    @currency = currency
  end

  def inspect
    sprintf "%.2f %s", amount.to_f, currency
  end

  def +(other)
    Money.new(amount + other.convert_to(currency).amount, currency)
  end

  def -(other)
    Money.new(amount - other.convert_to(currency).amount, currency)
  end

  def *(multiplier)
    Money.new((amount * multiplier).round(2), currency)
  end

  def /(divisor)
    Money.new((amount / divisor).round(2), currency)
  end

  def <=>(other)
    amount <=> other.convert_to(currency).amount
  end

  def convert_to(target_currency)
    return self if currency == target_currency 

    conversion_rate = @@conversion_rates[currency][target_currency]
    Money.new((amount * conversion_rate).round(2), target_currency)
  end

  def self.conversion_rates(base_currency, rates)
    @@conversion_rates = {base_currency => rates}

    currencies = rates.keys

    # calculate all the conversion rates
    currencies.each do |currency|
      reverse_rate = 1 / @@conversion_rates[base_currency][currency]
      @@conversion_rates[currency] = {base_currency => reverse_rate}

      currencies.each do |target_currency|
        next if target_currency == currency
        target_rate = reverse_rate * @@conversion_rates[base_currency][target_currency]
        @@conversion_rates[currency][target_currency] = target_rate
      end
    end
    @@conversion_rates
  end

end
