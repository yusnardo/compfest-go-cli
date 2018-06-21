# load file dari denah.rb
require_relative "denah"

def show_map(map)
  map.each do |line|
    line.each do |cell|
      print cell
    end
    puts ""
  end
end

def order(map)
  price = 300
  map_is_visited = Array.new(map.length) { Array.new(map.length, false) }
  begin
    print "your destination (X, Y) : "
    dest = gets.chomp
    dest = dest.split(" ")
    dest_pos_x = dest[0].to_i - 1
    dest_pos_y = dest[1].to_i - 1
  end while dest.length != 2 || !check_position(dest_pos_x, dest_pos_y, map.length)
  curr_pos_x = -1
  curr_pos_y = -1
  for i in 0...map.length
    found = false
    for j in 0...map.length
      if map[i][j] == "U"
        curr_pos_x = j
        curr_pos_y = i
        found = true
        break;
      end
    end
    if found
      break
    end
  end

  map[dest_pos_y][dest_pos_x] = "U"
  map[curr_pos_y][curr_pos_x] = "."
  driver_pos = finding_driver(curr_pos_x, curr_pos_y, map)
  total_cost = ((curr_pos_x - dest_pos_x).abs + (curr_pos_y- dest_pos_y).abs) * price
  text = "From position #{curr_pos_x + 1},#{curr_pos_y + 1} to #{dest_pos_x + 1},#{dest_pos_y + 1} with driver on position #{driver_pos[0] + 1},#{driver_pos[1] + 1} have cost : #{total_cost}"
  puts text
  File.write("driver_history.txt", text+"\n", mode: 'a')
  map
end

def finding_driver(pos_x, pos_y, map)
  found = false
  cur_rad = 1
  while(!found && cur_rad < map.length) do
    for dx in (cur_rad * -1)..cur_rad
      for dy in (cur_rad * -1)..cur_rad
        x = pos_x + dx
        y = pos_y + dy
        if !check_position(x,y,map.length)
          next
        end
        if map[y][x] != "U" && map[y][x] != "."
          return [x, y]
        end
      end
    end
    cur_rad += 1
  end
  [-1, -1]
end

def check_position(x, y, n)
  x >= 0 && x < n && y >= 0 && y < n
end

def view_history()
  memo = File.read("driver_history.txt").split("\n")
  if(memo.length == 0)
    puts "You dont have any order!"
  else
    puts "You totally have #{memo.length} orders, there are : "
    memo.each { |e|  puts e}
  end
end

def main
  map = generate_map()
  memo = []
  isRun = true
  while isRun
    puts "1. Show Map"
    puts "2. Order"
    puts "3. History"
    puts "4. Exit"
    print "Choose : "
    input = gets.chomp.to_i

    case input
    when 1
      show_map(map)
      puts "="*map.length
    when 2
      order = true
      while order
        map = order(map)
        print "Do you want to order again? (y/n) : "
        input = gets.chomp
        order = input == "y" ? true : false
      end
    when 3
      view_history()
    when 4
      isRun = false
      puts "Bye!"
    else
      puts "Input Not Valid"
    end
  end
end

main()