# Including necessary packages
using CSV
using DataFrames

# Function to read and process the CSV file
function read_csv_file(filepath::String)
    # Read the CSV file into a DataFrame
    df = CSV.read(filepath, DataFrame)

    # Display the first few rows of the DataFrame
    println("First few rows of the DataFrame:")
    show(df[1:5, :])

    # Accessing specific columns
    column1 = df[:, 1]
    column2 = df[:, 2]

    # Example: Display the first values of each column
    println("\nFirst value of Column 1: ", column1[1])
    println("First value of Column 2: ", column2[1])

    # Sort Column 1 individually
    sorted_column1 = sort(df[:, 1])
    println("\nSorted Column 1:")
    println(sorted_column1[1:5])

    # Sort Column 2 individually
    sorted_column2 = sort(df[:, 2])
    println("\nSorted Column 2:")
    println(sorted_column2[1:5])

    return sorted_column1, sorted_column2
end

function calc_distance(column1::Vector{Int64}, column2::Vector{Int64})
    total_distance = 0

    for i in 1:length(column1)
        distance = column1[i] - column2[i]
        total_distance = total_distance + abs(distance)
    end

    println("\n Total Distance")
    println(total_distance)
end

function calc_similarity(column1::Vector{Int64}, column2::Vector{Int64})

    total_sum = 0

    # println(count(x -> x == column1[1], column2))
    for i in 1:length(column1)

        similarity = column1[i] * count(x -> x == column1[i], column2)
        total_sum = total_sum + similarity
    end

    println("\n Total Similariyty")
    println(total_sum)
end

# Main program execution
function main()
    # Specify the path to your CSV file
    filepath = "data.csv"

    runtime = @elapsed begin
        sorted_column1, sorted_column2 = read_csv_file(filepath)
        calc_distance(sorted_column1, sorted_column2)
        calc_similarity(sorted_column1, sorted_column2)
    end
    println("Elapsed time: $runtime seconds")
end

# Program entry point
if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
