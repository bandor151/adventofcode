using CSV
using DataFrames
using IterTools

function read_csv_file(filepath::String)
    # Read the CSV file
    eq = CSV.read(filepath, DataFrame, header=false, delim=',')

    show(eq[1:5, :])
    return eq
end

function test_permut(row::DataFrameRow, permutation::Array{Int})
    result = row[2]

    for idx in 3:13
        if !ismissing(row[idx])
            if permutation[idx-2] == 1 # sum
                result = result + row[idx]
                # println(result)
            elseif permutation[idx-2] == 2 # mul
                result = result * row[idx]
            elseif permutation[idx-2] == 3 # concat
                result = parse(Int, string(result, row[idx]))
            end
        end
    end
    # println(row)
    # println(permutation)
    # println(result)
    return result == row[1]
end

function test_row(row::DataFrameRow)
    vec = [1, 2, 3]
    permutations = collect(product(vec, vec, vec, vec, vec, vec, vec, vec, vec, vec, vec, vec))
    for perm in permutations
        if test_permut(row, collect(perm))
            return true
        end
    end
    return false
end

function main()
    # Check how many threads we allow
    print("Number of Threads:")
    println(Threads.nthreads())

    # Get the map
    filepath_eq = "input_day7.csv"
    input_eq = read_csv_file(filepath_eq)

    println("\n")
    sum = 0
    sum_atomic = Threads.Atomic{Int}(0)
    runtime = @elapsed begin
        Threads.@threads for i in 1:850
            if test_row(input_eq[i, :])
                sum = sum + input_eq[i, 1]
                Threads.atomic_add!(sum_atomic, input_eq[i, 1])
            end
        end
    end
    println(sum)
    println("Elapsed time: $runtime seconds")
end

# Program entry point
if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
