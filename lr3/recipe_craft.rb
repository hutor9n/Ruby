module UnitConverter
  BASE_UNITS = {
    g: :g, kg: :g, ml: :ml, l: :ml, pcs: :pcs
  }.freeze

  CONVERSION_RATES = {
    g: 1, kg: 1000, ml: 1, l: 1000, pcs: 1
  }.freeze

  def self.to_base_unit(quantity, unit)
    rate = CONVERSION_RATES[unit]
    base_unit = BASE_UNITS[unit]
    raise "Unknown unit: #{unit}. Cannot convert." unless rate && base_unit
    [quantity * rate, base_unit]
  end
end

class Ingredient
  attr_reader :name, :base_unit, :calories_per_base_unit

  def initialize(name, base_unit, calories_per_base_unit)
    @name = name
    @base_unit = base_unit
    @calories_per_base_unit = calories_per_base_unit
  end
end

class Recipe
  attr_reader :name, :items, :steps

  def initialize(name, items, steps = [])
    @name = name
    @items = items
    @steps = steps
  end

  def need
    needed_in_base = Hash.new(0)
    @items.each do |item|
      ingredient_name = item[:ingredient].name.to_sym
      converted_qty, = UnitConverter.to_base_unit(item[:qty], item[:unit])
      needed_in_base[ingredient_name] += converted_qty
    end
    needed_in_base
  end
end

class Pantry
  def initialize
    @storage = Hash.new(0)
  end

  def add(name, qty, unit)
    converted_qty, base_unit = UnitConverter.to_base_unit(qty, unit)
    @storage[name.to_sym] += converted_qty
    puts "Added to pantry: #{name} - #{qty} #{unit} (as #{converted_qty} #{base_unit})."
  end

  def available_for(name)
    @storage[name.to_sym]
  end
end

class Planner
  def self.plan(recipes, pantry, price_list, calorie_list)
    puts 'Starting the planner!'
    total_needs = Hash.new(0)

    recipes.each do |recipe|
      recipe.need.each do |ingredient_name, needed_qty|
        total_needs[ingredient_name] += needed_qty
      end
    end

    total_calories = 0
    total_cost = 0

    puts "\nIngredient Report"
    all_ingredient_names = total_needs.keys.sort

    all_ingredient_names.each do |name|
      needed_qty = total_needs[name]
      have_qty = pantry.available_for(name)
      deficit = [0, needed_qty - have_qty].max

      puts "#{name.to_s.capitalize}: needed #{needed_qty}, have #{have_qty}, deficit #{deficit}"

      total_calories += needed_qty * calorie_list[name]
      total_cost += deficit * price_list[name] if price_list[name]
    end

    puts "\nSummary"
    puts "Total calories for planned meals: #{total_calories.round(2)} kcal"
    puts "Total cost for missing ingredients: #{total_cost.round(2)} UAH"
  end
end
