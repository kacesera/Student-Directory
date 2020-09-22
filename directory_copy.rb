def input_students
  puts ""
  puts "Please enter the names of the students:".center(50)
  puts "** To finish, just hit return twice **".center(50)
  puts "-------------".center(50)
  students = []
  name = gets.chomp.split.map(&:capitalize).join(' ')

  months = ["january", "february", "march", "april",
            "may", "june", "july", "august",
            "september", "october", "november", "december"]

  while !name.empty? do
    cohort = nil

    while !months.include?(cohort)
      if cohort == nil
        cohort = 'november'
      end

      puts "Please enter month of cohort:".center(50)
      cohort = gets.chomp.downcase
    end

    puts "Enter their hobby:".center(50)
    hobby = gets.chomp.downcase

    birth_date = get_birthdate

    students << {
      name: name,
      cohort: cohort.to_sym,
      birthdate: birth_date.to_sym,
      hobby: hobby
    }

    add_s = ""
    add_s = "s" if students.count > 1

    puts ""
    puts "Now we have #{students.count} student#{add_s}".center(50)
    puts "Please enter another student, or hit return to finish".center(50)
    puts ""
    name = gets.chomp
  end
  students
end

def get_birthdate
  date = nil

  until valid(date)
    puts "Enter their date of birth (DD/MM/YYYY)".center(50)
    date = gets.chomp.split("/").join
  end

  formatted_date = date.chars.insert(2, "/")
  formatted_date = formatted_date.insert(5, "/")

  formatted_date.join
end

def valid(date)
  return false if date == nil

  day = date[0..1].to_i
  month = date[2..3].to_i
  year = date[4..7].to_i
  leap_year = is_leap?(year)

  months = {
    1 => 31,
    2 => 28,
    3 => 31,
    4 => 30,
    5 => 31,
    6 => 30,
    7 => 31,
    8 => 31,
    9 => 30,
    10 => 31,
    11 => 30,
    12 => 31
  }

  if leap_year
    months[2] = 29
  end

  if date.size != 8 || !months.has_key?(month) || year.to_s.size != 4
    return false
  elsif day > months[month] || day < 1
    return false
  end

  true
end

def is_leap?(year)
  if year % 4 == 0 && year % 100 != 0 && year % 400 == 0
    return true
  end
  false
end

def print_header
  puts "The Students of Villains Academy".center(100)
  puts "-------------".center(100)
end

def print(people)
  months = ["january", "february", "march", "april",
            "may", "june", "july", "august",
            "september", "october", "november", "december"]

  months.each do |month|
    number = 1

    people.each do |person|
      cohort = person[:cohort]
      if cohort == month.to_sym
        puts " ~ Students in the #{cohort.capitalize} Cohort ~".center(100)
        puts "-------------".center(100)
        puts "#{number}. #{person[:name]} || DOB: #{person[:birthdate]}".center(100)
        number =+ 1
      end
    end
  end
end

def print_footer(names)
  add_s = ""
  add_s = "s" if names.count > 1

  puts "-------------".center(100)
  puts "Overall, we have #{names.count} great student#{add_s}".center(100)
end

students = input_students
print_header
print(students)
print_footer(students)
