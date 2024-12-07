function read_my_file(filepath::String)
        file_content = open(filepath, "r") do file
                read(file, String)
        end
        return file_content
end

function convert_to_matrix(map::String)
        lines = split(map, '\n')
        # map_m = [line for line in lines]
        map_m = [[Int(c) for c in line] for line in lines]
        # 46 = .
        # 35 = #
        # 60 = <
        # 62 = >
        # 94 = ^
        # 118 = v
        # 88 = X
        # 79 = O
        map_m = reduce(vcat, map_m[1:end-1]')
        return map_m
end

function find_guard(map::Matrix{Int})
        if (pos = findfirst(isequal(60), map)) !== nothing
                println("Guard is facing left")
                return findfirst(isequal(62), rot180(map)), rot180(map)
        elseif (pos = findfirst(isequal(62), map)) !== nothing
                println("Guard is facing right")
                return pos, map
        elseif (pos = findfirst(isequal(94), map)) !== nothing
                println("Guard is facing up")
                return findfirst(isequal(94), rotr90(map)), rotr90(map)
        elseif (pos = findfirst(isequal(116), map)) !== nothing
                println("Guard is facing down")
                return findfirst(isequal(116), rotl90(map)), rotl90(map)
        end
end

function move_guard(map::Matrix{Int}, pos::CartesianIndex{2})
        map[pos] = 88
        #Are we at the end?
        if pos[2] + 1 > size(map)[1] # Exit map
                return map, CartesianIndex(-1, -1), 0
                # Is there an obstacle?
        elseif map[pos[1], pos[2]+1] == 35 # Blocked
                # Rotate map & return new position
                # Because we transpose the map, we need to flip rows & cols
                return rotl90(map), CartesianIndex(131 - pos[2], pos[1] + 1), 1
        elseif map[pos[1], pos[2]+1] == 79 # Obstacle = Blocked
                # Rotate map & return new position
                # Because we transpose the map, we need to flip rows & cols
                return rotl90(map), CartesianIndex(131 - pos[2], pos[1] + 1), 2
        else # Move on
                new_pos = CartesianIndex(pos[1], pos[2] + 1)
                map[new_pos] = 94
                return map, new_pos, 3
        end
end

# We will walk the guard through the corse step by step
function walk_guard(map::Matrix{Int}, pos::CartesianIndex{2})
        step_cnt = 0
        watchdog = 0
        obstacle_cnt = 0
        while true
                map, pos, state = move_guard(map, pos)
                if state == 2
                        obstacle_cnt = obstacle_cnt + 1
                        if obstacle_cnt == 2000
                                return map, 1
                        end
                end
                step_cnt = step_cnt + 1
                if state == 0
                        break
                end
                watchdog = watchdog + 1
                if watchdog == 30000
                        println("watchdog $obstacle_cnt")
                        return map, 2
                end
        end
        # println(step_cnt)
        # println(map)
        return map, 0
end

# Place the obstacle at any possible point
function place_obstacle(map::Matrix{Int}, map_blocked::Matrix{Int}, pos::CartesianIndex{2}, obstacle::CartesianIndex{2})
        if map_blocked[obstacle] == 88 && obstacle !== pos # We will place only, where the guard walks, but not at the start
                map[obstacle] = 79
                map, state = walk_guard(map, pos)
                if state == 1 # We are stuck in a loop, which is what we want
                        # if state == 1 || state == 2 # We are stuck in a loop, which is what we want
                        println(obstacle)
                        return 1
                end
                return 2
        end
        return 3
end

function main()
        # Check how many threads we allow
        print("Number of Threads:")
        println(Threads.nthreads())

        # Get the map
        filepath_map = "input_day6"
        input_map = read_my_file(filepath_map)

        # Convert to Matrix
        map = convert_to_matrix(input_map)

        # Part1, where we find the blocked spots
        runtime = @elapsed begin
                pos_guard, map = find_guard(map)
        end
        println("Guard position (row, col) ($pos_guard[1], $pos_guard[2])")
        map_blocked, state = walk_guard(map, pos_guard)

        blocked = findall(isequal(88), map_blocked)
        print("Blocked postitions: ")
        println(length(blocked))
        println("Elapsed time: $runtime seconds")

        # Part2, where we place obstacels
        cnt = 0
        counter = Threads.Atomic{Int}(0)
        skip_counter = Threads.Atomic{Int}(0)
        used_counter = Threads.Atomic{Int}(0)
        skip_cnt = 0
        used_cnt = 0
        runtime = @elapsed begin
                # state = place_obstacle(map, map_blocked, pos_guard, CartesianIndex(1, 1))
                # println(map)
                for row in 1:size(map, 1)
                        Threads.@threads for col in 1:size(map, 2)
                                # for col in 1:size(map, 2)
                                state = place_obstacle(map, map_blocked, pos_guard, CartesianIndex(row, col))
                                if state == 1
                                        cnt = cnt + 1
                                        Threads.atomic_add!(counter, 1)
                                elseif state == 3
                                        skip_cnt = skip_cnt + 1
                                        Threads.atomic_add!(skip_counter, 1)
                                else
                                        used_cnt = used_cnt + 1
                                        Threads.atomic_add!(used_counter, 1)
                                end
                        end
                end
        end
        println("obstacle, skipped, used")
        println("$cnt, $skip_cnt, $used_cnt")
        println("$counter, $skip_counter, $used_counter")
        println("Elapsed time: $runtime seconds")
end

# Program entry point
if abspath(PROGRAM_FILE) == @__FILE__
        main()
end
