def generate_map(*args)
  if args[0].is_a? String
    grid = []
    (File.read args[0]).split("\n").each do |line|
      grid.push(line.split(""))
    end
    grid
  else
    n = args[0].is_a?(Integer) ? args[0] : 20
    x = args[1].is_a?(Integer) ? args[1] : rand(n+1)
    y = args[2].is_a?(Integer) ? args[2] : rand(n+1)

    grid = Array.new(n) { Array.new(n, ".") }
    grid[y-1][x-1] = "U"
    5.times do
      begin
        x = rand(n+1)
        y = rand(n+1)
      end while grid[y-1][x-1] == "D" || grid[y-1][x-1] == "U"
      grid[y-1][x-1] = "D"
    end
    grid
  end
end