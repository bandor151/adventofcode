# The puzzleVector{Vector{Int64}} for day3 of the advent of code event 2024
# This is not about efficency. It is about testing different ways.
#
using ImageTransformations

function read_my_file(filepath::String)
    file_content = open(filepath, "r") do file
        read(file, String)
    end
    return file_content
end

#Lets convert XMAS to 1234, as nummerical vectors are easier to handle
function convert_to_numeric(puzzle::String)
    puzzle_num = replace(puzzle, "X" => "1", "M" => "2", "A" => "3", "S" => "4")
    return puzzle_num
end

#Lets make this text a matrix of ints
function convert_to_matrix_int(puzzle::String)
    lines = split(puzzle, '\n')
    puzzle_m = [[Int(c) for c in line] for line in lines]
    return puzzle_m
end

#Lets make this text a matrix of ints
function convert_to_matrix(puzzle::String)
    lines = split(puzzle, '\n')
    puzzle_m = [collect(line) for line in lines]
    return puzzle_m
end

#Lets make this matrix a string
function convert_to_string(puzzle::Vector{Vector{Int64}})
    puzzle_s = join([join(map(x -> Char(x), row)) for row in puzzle], '\n')
    return puzzle_s
end

#Count the number of XMAS in the string forward and backwards
function count_XMAS(puzzle::String)
    matches_f = eachmatch(r"XMAS", puzzle)
    matches_b = eachmatch(r"SAMX", puzzle)
    return length(collect(matches_f)) + length(collect(matches_b))
end

function puzzle_transpose(puzzle::Vector{Vector{Int64}})
    puzzle_t = copy(puzzle)
    row_cnt = 1
    col_cnt = 1
    for row in 1:length(puzzle[1])
        for element in 1:length(row)
            puzzle_t[row_cnt][col_cnt] = element
            row_cnt = row_cnt + 1
        end
        row_cnt = 1
        col_cnt = col_cnt + 1
    end
    return puzzle_t
end


#Rotate the matrix
function rotlx(puzzle::Vector{Vector{Int64}}, angle)
    # I dont like this approach, lets try differnt
    matrix = Matrix{Int64}(puzzle)
    matrix = Matrix{Float64}(reduce(hcat, puzzle))
    matrix = reshape(puzzle, size(puzzle)...)
    println(size(matrix))
    matrix = imrotate(matrix, π / 2)
    println(matrix)
end

# Lets check every element in any direction. This less elegant, but maybe more efficient
function check_each_element(puzzle::Vector{Vector{Char}})
    match_cnt = 0
    dim = length(puzzle[1])
    for row in 1:dim
        for col in 1:dim
            #Forward
            if !(col + 3 > dim)
                if puzzle[row][col] == 'X' && puzzle[row][col+1] == 'M' && puzzle[row][col+2] == 'A' && puzzle[row][col+3] == 'S'
                    match_cnt = match_cnt + 1
                end
            end

            #Backwards
            if col > 3
                if puzzle[row][col] == 'X' && puzzle[row][col-1] == 'M' && puzzle[row][col-2] == 'A' && puzzle[row][col-3] == 'S'
                    match_cnt = match_cnt + 1
                end
            end

            #Down
            if !(row + 3 > dim)
                if puzzle[row][col] == 'X' && puzzle[row+1][col] == 'M' && puzzle[row+2][col] == 'A' && puzzle[row+3][col] == 'S'
                    match_cnt = match_cnt + 1
                end
            end

            #Up
            if row > 3
                if puzzle[row][col] == 'X' && puzzle[row-1][col] == 'M' && puzzle[row-2][col] == 'A' && puzzle[row-3][col] == 'S'
                    match_cnt = match_cnt + 1
                end
            end

            #Top left, bottom right
            if !(row + 3 > dim) && !(col + 3 > dim)
                if puzzle[row][col] == 'X' && puzzle[row+1][col+1] == 'M' && puzzle[row+2][col+2] == 'A' && puzzle[row+3][col+3] == 'S'
                    match_cnt = match_cnt + 1
                end
            end

            #Top right, bottom left
            if !(row + 3 > dim) && (col > 3)
                if puzzle[row][col] == 'X' && puzzle[row+1][col-1] == 'M' && puzzle[row+2][col-2] == 'A' && puzzle[row+3][col-3] == 'S'
                    match_cnt = match_cnt + 1
                end
            end

            #Bottom left, Top right
            if (row > 3) && !(col + 3 > dim)
                if puzzle[row][col] == 'X' && puzzle[row-1][col+1] == 'M' && puzzle[row-2][col+2] == 'A' && puzzle[row-3][col+3] == 'S'
                    match_cnt = match_cnt + 1
                end
            end

            #Bottom right, Top right
            if (row > 3) && (col > 3)
                if puzzle[row][col] == 'X' && puzzle[row-1][col-1] == 'M' && puzzle[row-2][col-2] == 'A' && puzzle[row-3][col-3] == 'S'
                    match_cnt = match_cnt + 1
                end
            end
        end
    end
    println(match_cnt)
end

# Lets check every element in any direction. Same approach as for part1, but now the different X-MAS
function check_each_element_part2(puzzle::Vector{Vector{Char}})
    match_cnt = 0
    dim = length(puzzle[1])
    for row in 1:dim
        for col in 1:dim
            #Top left, bottom right
            #Check for combinations back and forth
            if !(row + 2 > dim) && !(col + 2 > dim)
                if puzzle[row][col] == 'M' && puzzle[row+1][col+1] == 'A' && puzzle[row+2][col+2] == 'S'
                    if (puzzle[row+2][col] == 'M' && puzzle[row+1][col+1] == 'A' && puzzle[row][col+2] == 'S') ||
                       (puzzle[row+2][col] == 'S' && puzzle[row+1][col+1] == 'A' && puzzle[row][col+2] == 'M')
                        match_cnt = match_cnt + 1
                    end
                elseif puzzle[row][col] == 'S' && puzzle[row+1][col+1] == 'A' && puzzle[row+2][col+2] == 'M'
                    if (puzzle[row+2][col] == 'M' && puzzle[row+1][col+1] == 'A' && puzzle[row][col+2] == 'S') ||
                       (puzzle[row+2][col] == 'S' && puzzle[row+1][col+1] == 'A' && puzzle[row][col+2] == 'M')
                        match_cnt = match_cnt + 1
                    end
                end
            end
        end
    end
    println(match_cnt)
end

# Main program execution
function main()
    filepath = "data"

    runtime = @elapsed begin
        # Read the files first
        puzzle = read_my_file(filepath)
        puzzle_i = convert_to_matrix_int(puzzle)
        puzzle_c = convert_to_matrix(puzzle)

        # First check for rotation 0 and π
        # println(count_XMAS(puzzle))

        # Check for rotation π/2 and 3π/2
        # puzzle_t = puzzle_transpose(puzzle_i[1:end-1])
        # puzzle = convert_to_string(puzzle_t)
        # println(count_XMAS(puzzle))

        # Check for rotation π/4 and 7π/4
        # rotlx(puzzle_i[1:end-1], 45)
        # puzzle = convert_to_string(puzzle_i)
        # println(count_XMAS(puzzle))

        # This is not elegant but faster
        println("\nPart 1")
        check_each_element(puzzle_c[1:end-1])

        println("\nPart 2")
        check_each_element_part2(puzzle_c[1:end-1])
    end
    println("Elapsed time: $runtime seconds")
end

# Program entry point
if abspath(PROGRAM_FILE) == @__FILE__
    main()
end

