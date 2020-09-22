def input_students
  puts "Please enter the names of the students"
  puts "to finish, just hit return twice"
  students = []
  name = get.chomp

  while !name.empty? do
    students << {name: name, cohort: :november}
    puts "Now we have #{students.count} students"
    nem = gets.chomp
  end
  students
end

def print_header
  puts "The Students of Villains Academy"
  puts "-------------"
end

def print(people)
  people.each do |person|
    puts "#{person[:name]} (#{person[:cohort]} cohort)"
  end
end

def print_footer(names)
  puts "Overall, we have #{names.count} great students"
end

students = input_students
print_header
print(students)
print_footer(students)
