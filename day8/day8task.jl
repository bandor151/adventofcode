# Lets check what day8 has for us.
# Today I want to take care a bit more about reading the files.
# Especially I am not happy with all those typeconversion, which cost time
# For the sake of learning I want to use dicts/hashmaps today
#
function read_file(filepath::String)
    open(filepath) do file
        lines = readlines(file)
        num_rows = length(lines)
        num_cols = maximum(length.(lines))
        println("Matrix size: $num_rows by $num_cols")

        # This is for testing and debugging only I want to know what is faster
        runtime = @elapsed begin
            matrix = Matrix{Char}(undef, num_rows, num_cols)
            for (row, line) in enumerate(lines)
                for (col, element) in enumerate(line)
                    matrix[row, col] = element
                end
            end

            antenna_ma = Dict{Char,Vector{NTuple{2,Int}}}()

            for row in 1:num_rows
                for col in 1:num_cols
                    element = matrix[row, col]
                    if isletter(element) || isdigit(element)
                        if haskey(antenna_ma, element)
                            push!(antenna_ma[element], (row, col))
                        else
                            antenna_ma[element] = [(row, col)]
                        end
                    end
                end
            end
        end
        # println("Elapsed time: $runtime seconds")

        antenna_map = Dict{Char,Vector{NTuple{2,Int}}}()

        runtime = @elapsed for (row, line) in enumerate(lines)
            for (col, element) in enumerate(line)
                if isletter(element) || isdigit(element)
                    if haskey(antenna_map, element)
                        push!(antenna_map[element], (row, col))
                    else
                        antenna_map[element] = [(row, col)]
                    end
                end
            end
        end
        # println("Elapsed time: $runtime seconds")

        # The speed difference is not measureable with such small data.
        # I need to test on a larger set of data

        # Display the hashtable
        # for (char, positions) in antenna_map
        #     println("Character: '$char' at Positions: $positions")
        # end

        return antenna_map
    end
end

# For two antennas at the same frequency calculate the two antinodes
# Some might be outside of the map
function get_antinods(antennas::Vector{NTuple{2,Int}})
    antinodes = Vector{NTuple{2,Int}}()
    for pos1 in 1:length(antennas)-1
        for pos2 in pos1+1:length(antennas)
            distance = antennas[pos2] .- antennas[pos1]
            # println(distance)
            antinode1 = antennas[pos1] .- distance
            antinode2 = antennas[pos2] .+ distance
            if antinode1[1] >= 1 && antinode1[2] >= 1 && antinode1[1] <= 50 && antinode1[2] >= 1 && antinode1[2] <= 50
                # println("Antinode 1 : $antinode1")
                append!(antinodes, tuple(antinode1))
            end
            if antinode2[1] >= 1 && antinode2[2] >= 1 && antinode2[1] <= 50 && antinode2[2] >= 1 && antinode2[2] <= 50
                # println("Antinode 2: $antinode2")
                append!(antinodes, tuple(antinode2))
            end
        end
    end
    # println(antinodes)
    return antinodes
end

function main()
    # Check how many threads we allow
    print("Number of Threads:")
    println(Threads.nthreads())

    # Get the map
    filepath_map = "input"
    antenna_map = read_file(filepath_map)

    antinodes = Vector{NTuple{2,Int}}()
    runtime = @elapsed begin
        for (key, value) in antenna_map
            append!(antinodes, get_antinods(antenna_map[key]))
            # Next time I have to think about how to remove duplicates more efficient by utilizing sets
        end
        println("\n")
        println(unique(antinodes))
        println(length(unique(antinodes)))
    end
    println("Elapsed time: $runtime seconds")
end

# Program entry point
if abspath(PROGRAM_FILE) == @__FILE__
    main()
end