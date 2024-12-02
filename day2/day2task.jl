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

    return df
end

function is_sorted_increasing(vec::Vector)
    non_missing = filter(!ismissing, vec)
    return all(x -> x[1] <= x[2], zip(non_missing, non_missing[2:end]))
end

function is_sorted_decreasing(vec::Vector)
    non_missing = filter(!ismissing, vec)
    return all(x -> x[1] >= x[2], zip(non_missing, non_missing[2:end]))
end

function filter_increasing(report::DataFrame)
    sorted_rows = [is_sorted_increasing(collect(row)) || is_sorted_decreasing(collect(row)) for row in eachrow(report)]
    report_sorted = report[sorted_rows, :]
    return report_sorted
end

function check_distance(report::Vector)
    non_missing = filter(!ismissing, report)
    if length(non_missing) <= 2
        return true
    end
    max_distance = maximum(abs.(diff(non_missing)))
    min_distance = minimum(abs.(diff(non_missing)))

    return min_distance >= 1 && max_distance <= 3
end

function filter_distance(report::DataFrame)
    valid_rows = [check_distance(collect(row)) for row in eachrow(report)]
    report_valid = report[valid_rows, :]

    return report_valid
end

function check_all(row::Vector)
    if (is_sorted_increasing(row) || is_sorted_decreasing(row)) && check_distance(row)
        return true
    end
    non_missing = filter(!ismissing, row)
    if length(non_missing) <= 2
        return true
    end
    for i in 1:length(non_missing)
        tmp_vec = copy(non_missing)
        deleteat!(tmp_vec, i)
        if (is_sorted_increasing(tmp_vec) || is_sorted_decreasing(tmp_vec)) && check_distance(tmp_vec)
            return true
        end
    end
    return false
end

function filter_all(report::DataFrame)
    good_rows = [check_all(collect(row)) for row in eachrow(report)]
    report_good = report[good_rows, :]

    return report_good
end

# Main program execution
function main()
    filepath = "data.csv"

    runtime = @elapsed begin
        report = read_csv_file(filepath)
        println("\n Total number of rows: ")
        println(nrow(report))
        report_sorted = filter_increasing(report)
        println("\n Number of rows, which are sorted: ")
        println(size(report_sorted))
        report_valid = filter_distance(report_sorted)
        println("\n Number of rows, which are valid: ")
        println(size(report_valid))

        report_good = filter_all(report)
        println("\n Number of good rows: ")
        println(size(report_good))
    end
    println("Elapsed time: $runtime seconds")
end

# Program entry point
if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
