# frozen_string_literal: true

# provides correct pluralization format given singular, plural and number
# inspired by https://stackoverflow.com/a/3030973/316729
class Pluralize
  def self.format(number, singular, plural = nil)
    return "1 #{singular}" if number == 1
    return "#{number} #{plural}" if plural

    "#{number} #{singular}s"
  end
end
