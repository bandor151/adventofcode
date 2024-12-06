function read_my_file(filepath::String)
    file_content = open(filepath, "r") do file
        read(file, String)
    end
    return file_content
end

function convert_to_matrix(map::String)
    lines = split(map, '\n')
	#map_m = [line for line in lines]
	map_m = [[Int(c) for c in line] for line in lines]
	# 46 = .
	# 35 = #
	# 60 = <
	# 62 = >
	# 94 = ^
	# 118 = v
	map_m = reduce(hcat, map_m[1:end-1])
    return map_m
end

function find_guard(map::Matrix{Int}) 
	if (pos = findfirst(isequal(60), map)) != nothing
		println("Guard is facing left")
		return findfirst(isequal(62), rot180(map)), rot180(map)
	elseif (pos = findfirst(isequal(62), map)) != nothing
		println("Guard is facing right")
		return pos, map
	elseif (pos = findfirst(isequal(94), map)) != nothing
		println("Guard is facing up")
		return findfirst(isequal(94), rotr90(map)), rotr90(map)
	elseif (pos = findfirst(isequal(116), map)) != nothing
		println("Guard is facing down")
		return findfirst(isequal(116), rotl90(map)), rotl90(map)
	end
end

function move_guard(map::Matrix{Int}, pos::CartesianIndex{2})
	map[pos] = 88	
	#Are we at the end?
	if pos[1]+1 > size(map)[1]
		println("End")
		return map, CartesianIndex(-1, -1)
	# Is there an obstacle?
	elseif map[pos[1]+1, pos[2]] == 35
		# Rotate map & return new position
		# Because we transpose the map, we need to flip rows & cols
		return rotl90(map), CartesianIndex(pos[2], pos[1] + 1)
	# Move on
	else
		return map, CartesianIndex(pos[1] + 1, pos[2])
	end
end

begin
	# Get the map
	filepath_map = "input_day6.txt"
	input_map = read_my_file(filepath_map)

	# Convert to Matrix
	map = convert_to_matrix(input_map)
	pos_guard, map= find_guard(map)
	println("Guard position (col, row)")
	println(pos_guard[1])
	println(pos_guard[2])
	step_cnt = 0
	while pos_guard[1] != -1
		map, pos_guard = move_guard(map, pos_guard)
		step_cnt = step_cnt + 1
	end
	println("Steps the guard walked")
	println(step_cnt)
	blocked = findall(isequal(88), map)
	println("Blocked postitions")
	println(length(blocked))
end
