# The puzzle for day3 of the advent of code event 2024
# This is not about efficency. It is about learning a couple of new things.
#
function read_my_file(filepath::String)
    file_content = open(filepath, "r") do file
        read(file, String)
    end
    return file_content
end

function valid_code(memory::String)
    cleaned_memory = replace(memory, r"(don't\(\)).*?(do\(\))" => "invalid")
    println(cleaned_memory)
    return cleaned_memory
end

function find_mul(memory::String)
    # \d any digit
    # {n,m} match at least n but at most m
    pattern = "mul\\(\\d{1,3},\\d{1,3}\\)"
    matches = eachmatch(Regex(pattern), memory)
    muls = collect(matches)
    muls_striped = [match.match for match in muls]
    muls_striped = [strip(match, ['(', ')', 'm', 'u', 'l']) for match in muls_striped]
    return [split(mul, ',') for mul in muls_striped]
end

function mac(locations::Vector{Vector{SubString{String}}})
    acc = 0
    for i in 1:length(locations)
        acc = acc + parse(Int, locations[i][1]) * parse(Int, locations[i][2])
    end
    println(acc)
    return acc
end

# Main program execution
function main()
    filepath = "data"

    runtime = @elapsed begin
        memory = read_my_file(filepath)
        # println(memory)
        # memory = valid_code(memory)
        locations = find_mul(memory)
        mac(locations[:])
    end
    println("Elapsed time: $runtime seconds")
end

# Program entry point
if abspath(PROGRAM_FILE) == @__FILE__
    main()
end

