require_relative 'recipe_craft.rb'

puts 'Creating ingredient database'
EGG = Ingredient.new('egg', :pcs, 72)
MILK = Ingredient.new('milk', :ml, 0.06)
FLOUR = Ingredient.new('flour', :g, 3.64)
PASTA = Ingredient.new('pasta', :g, 3.5)
SAUCE = Ingredient.new('sauce', :ml, 0.2)
CHEESE = Ingredient.new('cheese', :g, 4.0)
puts "Ingredient database created.\n\n"

puts 'Stocking the pantry'
pantry = Pantry.new
pantry.add('flour', 1, :kg)
pantry.add('milk', 0.5, :l)
pantry.add('egg', 6, :pcs)
pantry.add('pasta', 300, :g)
pantry.add('cheese', 150, :g)
puts "Pantry is stocked.\n\n"

price_list = {
  flour: 0.02,
  milk: 0.015,
  egg: 6.0,
  pasta: 0.03,
  sauce: 0.025,
  cheese: 0.08
}

calorie_list = {
  egg: EGG.calories_per_base_unit,
  milk: MILK.calories_per_base_unit,
  flour: FLOUR.calories_per_base_unit,
  pasta: PASTA.calories_per_base_unit,
  sauce: SAUCE.calories_per_base_unit,
  cheese: CHEESE.calories_per_base_unit
}

omelette_items = [
  { ingredient: EGG, qty: 3, unit: :pcs },
  { ingredient: MILK, qty: 100, unit: :ml },
  { ingredient: FLOUR, qty: 20, unit: :g }
]
omelette = Recipe.new('Omelette', omelette_items)

pasta_items = [
  { ingredient: PASTA, qty: 200, unit: :g },
  { ingredient: SAUCE, qty: 150, unit: :ml },
  { ingredient: CHEESE, qty: 50, unit: :g }
]
pasta_recipe = Recipe.new('Pasta with cheese', pasta_items)

recipes_to_cook = [omelette, pasta_recipe]

Planner.plan(recipes_to_cook, pantry, price_list, calorie_list)
