input = File.read("input").split("\n\n")

map = input[0].lines.map(&:chomp).map(&:chars)
path = input[1].scan(/(\d+)([RL]?)/).map do |steps, turn|
  [steps.to_i, {"R" => :right, "L" => :left}[turn]]
end

def out_of_bounds?(x, y, map)
  x < 0 || y < 0 || map[y] == nil || map[y][x] == nil || map[y][x] == " "
end

def wrap(x, y, dir, map)
  cur_x, cur_y = case dir
  when [1, 0] then [0, y]
  when [-1, 0] then [map[y].length - 1, y]
  when [0, 1] then [x, 0]
  when [0, -1] then [x, map.length - 1]
  end

  loop do
    case map[cur_y][cur_x]
    when "."
      return [cur_x, cur_y]
    when "#"
      return [x, y]
    end

    cur_x += dir[0]
    cur_y += dir[1]
  end
end

def move(x, y, dir, map)
  next_x, next_y = x + dir[0], y + dir[1]

  return wrap(x, y, dir, map) if out_of_bounds?(next_x, next_y, map)

  case map[next_y][next_x]
  when "."
    [next_x, next_y]
  when "#"
    [x, y]
  end
end

def rotate(dir, turn)
  case turn
  when :right
    case dir
    when [1, 0] then [0, 1]
    when [0, 1] then [-1, 0]
    when [-1, 0] then [0, -1]
    when [0, -1] then [1, 0]
    end
  when :left
    case dir
    when [1, 0] then [0, -1]
    when [0, -1] then [-1, 0]
    when [-1, 0] then [0, 1]
    when [0, 1] then [1, 0]
    end
  end
end

x = map[0].find_index(".")
y = 0
dir = [1, 0]

path.each do |steps, turn|
  steps.times do
    x, y = move(x, y, dir, map)
  end

  dir = rotate(dir, turn) if turn
end

facing = case dir
when [1, 0] then 0
when [0, 1] then 1
when [-1, 0] then 2
when [0, -1] then 3
end

password = (1000 * (y + 1)) + (4 * (x + 1)) + facing

p password