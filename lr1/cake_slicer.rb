def slice_cake(cake_str)
  h = cake_str.count("\n") + 1
  w = cake_str.index("\n")

  points = []
  pos = -1
  while pos = cake_str.index('o', pos + 1)
    y = pos / (w + 1)
    x = pos % (w + 1)
    points.push([y, x])
  end

  total_cells = w * h
  cells = total_cells / points.size
  rest  = total_cells % points.size
  return [] unless rest == 0

  shapes = []
  col = w
  while col >= 1
    row = cells / col
    rem = cells % col
    if rem == 0 && row <= h
      shapes.push([row, col])
    end
    col -= 1
  end

  result = try_split(shapes, h, w, points)
  final_result = []

  if result
    i = 0
    while i < result.size
      rows_range, cols_range = result[i][0], result[i][1]
      piece_lines = []

      rows_range.each do |yy|
        line_chars = []
        cols_range.each do |xx|
          line_chars.push(cake_str[yy * (w + 1) + xx])
        end
        piece_lines.push(line_chars.join)
      end

      final_result.push(piece_lines.join("\n"))
      i += 1
    end
  end

  final_result
end

def try_split(shapes, h, w, points, cuts = [])
  parts = validate_cut(cuts, h, w, points)
  return false unless parts
  return parts if parts.size == points.size

  i = 0
  while i < shapes.size
    sh = shapes[i]
    res = try_split(shapes, h, w, points, cuts + [sh])
    return res if res
    i += 1
  end
  false
end

def first_corner(parts, mask)
  y = 0
  while y < mask.size
    x = 0
    while x < mask[0].size
      return [y, x] if mask[y][x] == 1
      x += 1
    end
    y += 1
  end
  false
end

def validate_cut(shapes, h, w, points)
  parts = []
  mask = []
  i = 0
  while i < h
    mask.push(Array.new(w, 1))
    i += 1
  end

  i = 0
  while i < shapes.size
    sh = shapes[i]
    corner = first_corner(parts, mask)
    if corner
      y2 = corner[0] + sh[0] - 1
      x2 = corner[1] + sh[1] - 1
      return false if y2 >= h || x2 >= w

      rng_y = (corner[0]..y2)
      rng_x = (corner[1]..x2)

      count = 0
      j = 0
      while j < points.size
        yy, xx = points[j][0], points[j][1]
        if yy >= rng_y.begin && yy <= rng_y.end && xx >= rng_x.begin && xx <= rng_x.end
          count += 1
        end
        j += 1
      end
      return false unless count == 1

      y = rng_y.begin
      while y <= rng_y.end
        x = rng_x.begin
        while x <= rng_x.end
          return false if mask[y][x] == 0
          mask[y][x] = 0
          x += 1
        end
        y += 1
      end

      parts.push([rng_y, rng_x])
    end
    i += 1
  end

  parts
end

def cake_cook
  r = Random.new
  num = r.rand(2...10)
  rows, cols = 6, 8
  matrix = []
  i = 0
  while i < rows
    matrix.push(Array.new(cols, '.'))
    i += 1
  end

  placed = 0
  while placed < num
    ry = r.rand(0...rows)
    rx = r.rand(0...cols)
    if matrix[ry][rx] == '.'
      matrix[ry][rx] = 'o'
      placed += 1
    end
  end

  cake = ""
  i = 0
  while i < rows
    cake += matrix[i].join
    cake += "\n" if i != rows - 1
    i += 1
  end

  puts "Random cake:\n#{cake}\n\n"
  cake
end

cake = cake_cook
pieces = slice_cake(cake)

if pieces.empty?
  puts "Impossible to divide to equal parts."
else
  puts "["
  i = 0
  while i < pieces.size
    piece = pieces[i]
    lines = piece.split("\n")
    j = 0
    while j < lines.size
      puts "  " + lines[j]
      j += 1
    end
    puts "  ," unless i == pieces.size - 1
    i += 1
  end
  puts "]"
end

