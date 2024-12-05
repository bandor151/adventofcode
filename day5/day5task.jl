### A Pluto.jl notebook ###
# v0.20.3

using Markdown
using InteractiveUtils

# ╔═╡ 8b2f2182-b31d-11ef-0bdc-49277e5e35f4
function read_my_file(filepath::String)
    file_content = open(filepath, "r") do file
        read(file, String)
    end
    return file_content
end

# ╔═╡ f300f9e0-eb3b-4f82-8b96-9e748fbf9954
function parse_file_rules(input::String)
	lines = split(input, "\n")
	rules = [split(rules, "|") for rules in lines]
	rules = [[parse(Int, value) for value in rule] for rule in rules]
	return rules
end

# ╔═╡ 7d589488-5de0-4913-8d7b-b778860e925a
function parse_file_updates(input::String)
	lines = split(input, "\n")
	updates = [split(update, ",") for update in lines]
	updates = [[parse(Int, value) for value in update] for update in updates]
	return updates
end

# ╔═╡ 6b5c0d7a-612b-4a3c-b575-f4bb8122260c
function update_check(rules::Vector{Vector{Int}}, update::Vector{Int})
	for page_num in 1:length(update)
		for rule in rules
			if rule[1] == update[page_num]
				for prev_page_num in 1:page_num
					if rule[2] == update[prev_page_num]
						return false, page_num, prev_page_num
					end
				end
			end
		end
	end
	return true, 0, 0
end

# ╔═╡ cc6fc3ea-ffb3-47ad-bbfe-0c62b0c2fa40
function fix_update(rules::Vector{Vector{Int}}, update::Vector{Int})
	correct, page, prev_page = update_check(rules, update)
	#println(correct)
	#println(page)
	#println(prev_page)
	#println(update)
	permutation = collect(1:length(update))
	while !correct
		cnt_permut = 1
		for i in 1:length(update)
			if i == prev_page
				permutation[i] = page
			elseif cnt_permut == page
				cnt_permut = cnt_permut + 1
				permutation[i] = cnt_permut
				cnt_permut = cnt_permut + 1
			else
				permutation[i] = cnt_permut
				cnt_permut = cnt_permut + 1
			end
		end
		#println(permutation)
		permute!(update, permutation)
		correct, page, prev_page = update_check(rules, update)
	end
	#update_fixed = 
	# check if there is a single incorrect rule
end

# ╔═╡ 05fc676d-94e2-488e-938f-b859c83ab90d
begin
	# Get the ruleset
	filepath_rules = "input_rules.txt"
	input_rules = read_my_file(filepath_rules)
	rules = parse_file_rules(input_rules)

	# Get updates
	filepath_updates = "input_updates.txt"
	input_updates = read_my_file(filepath_updates)
	updates = parse_file_updates(input_updates)

	middle_sum = 0
	middle_sum_fixed = 0
	for update in updates
		correct, page_num, rule = update_check(rules, update)
		if correct
			middle_sum = middle_sum + update[Int((length(update)+1)/2)]
		else
			fix_update(rules, update)
			middle_sum_fixed = middle_sum_fixed + update[Int((length(update)+1)/2)]
		end
	end
	println("Sum of valid updates middle is")
	println(middle_sum)

	println("Sum of fixed updates middle is")
	println(middle_sum_fixed)
end

# ╔═╡ Cell order:
# ╠═8b2f2182-b31d-11ef-0bdc-49277e5e35f4
# ╠═f300f9e0-eb3b-4f82-8b96-9e748fbf9954
# ╠═7d589488-5de0-4913-8d7b-b778860e925a
# ╠═6b5c0d7a-612b-4a3c-b575-f4bb8122260c
# ╠═cc6fc3ea-ffb3-47ad-bbfe-0c62b0c2fa40
# ╠═05fc676d-94e2-488e-938f-b859c83ab90d
