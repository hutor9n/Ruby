require 'csv'
require 'time'
require 'bigdecimal'


class StreamingCsvParser
  CUSTOM_CASTERS = {
    'int' => ->(value) { value.to_i rescue value },
    'decimal' => ->(value) { BigDecimal(value.to_s) rescue value },
    'time' => ->(value) { Time.parse(value) rescue value }
  }.freeze

  def self.parse(file_path, column_types)
    caster_map = {}

    CSV.foreach(file_path, headers: true, return_headers: false) do |row|
      if caster_map.empty?
        column_types.each do |col_name, type|
          index = row.headers.index(col_name.to_s)
          caster = CUSTOM_CASTERS[type.to_s.downcase]
          caster_map[index] = caster if index && caster
        end
      end

      caster_map.each do |index, caster_func|
        value = row[index]
        row[index] = caster_func.call(value) unless value.nil?
      end

      yield row.to_h
    end
  end
end

TEST_CSV_FILE = 'data.csv'

COLUMN_CASTS = {
  'id' => 'int',
  'price' => 'decimal',
  'timestamp' => 'time'
}

record_count = 0

StreamingCsvParser.parse(TEST_CSV_FILE, COLUMN_CASTS) do |record|
  record_count += 1
  puts "\nRecord ##{record_count}:"
  
  record.each do |key, value|
    puts "  #{key.ljust(10)}: #{value.inspect} (Type: #{value.class})"
  end
end

puts "\nTotal Records: #{record_count}"
