@filename = ARGV.first
@students = []
@months = [
  {month: :january, days: 31},
  {month: :february, days: 28},
  {month: :march, days: 31},
  {month: :april, days: 30},
  {month: :may, days: 31},
  {month: :june, days: 30},
  {month: :july, days: 31},
  {month: :august, days: 31},
  {month: :september, days: 30},
  {month: :october, days: 31},
  {month: :november, days: 30},
  {month: :december, days: 31},
]
def add_students(name, cohort, birthdate, hobby)
  person = {
    name: name,
    cohort: cohort.to_sym,
    birthdate: birthdate.to_sym,
    hobby: hobby
  }
  if !person_included?(person)
    @students << person
  end
end

def input_students
  puts ""
  puts "Please enter the names of the students:".center(50)
  puts "** To finish, just hit return twice **".center(50)
  puts "-------------".center(50)
  name = STDIN.gets.chomp

  while !name.empty? do
    cohort = nil
    name = proper_capitalize(name)

    while !month_included?(cohort)
      puts "Please enter month of cohort:".center(50)
      cohort = STDIN.gets.chomp.downcase
    end

    puts "Enter their hobby:".center(50)
    hobby = STDIN.gets.chomp.downcase

    birthdate = get_birthdate

    add_students(name, cohort, birthdate, hobby)
    print_num_students

    name = STDIN.gets.chomp
  end
end

def print_num_students
  add_s = ""
  add_s = "s" if @students.count > 1

  puts ""
  puts "Now we have #{@students.count} student#{add_s}".center(50)
  puts "Please enter another student, or hit return to finish".center(50)
  puts ""
end

def month_included?(cohort)
  return false if cohort.nil?
  @months.each do |month|
    return true if month[:month] == cohort.to_sym
  end
  false
end

def person_included?(person)
  return false if @students.nil?
  @students.each do |student|
    return true if student == person
  end
  false
end

def proper_capitalize(name)
  if name.split.count == 1
    return name.capitalize
  else
    return name.split.map(&:capitalize).join(' ')
  end
end

def get_birthdate
  date = nil

  until valid(date)
    puts "Enter their date of birth (DD/MM/YYYY)".center(50)
    date = STDIN.gets.chomp.split("/").join
  end

  formatted_date = date.chars.insert(2, "/")
  formatted_date = formatted_date.insert(5, "/")

  formatted_date.join
end

def valid(date)
  return false if date.nil?

  day = date[0..1].to_i
  month = date[2..3].to_i
  year = date[4..7].to_i
  index = month - 1

  is_leap?(year)

  if date.size != 8 || month > 12 || month < 0 || year.to_s.size != 4
    return false
  elsif day > @months[index][:days] || day < 1
    return false
  end

  true
end

def is_leap?(year)
  if year % 4 == 0 && year % 100 != 0 && year % 400 == 0
    @months[1][:days] = 29
  else
    @months[1][:days] = 28
  end
end

def print_header
  puts "The Students of Villains Academy".center(100)
end

def print_students_list
  if @students.nil? || @students.empty?
    puts "There are currently 0 students".center(100)
  else
    get_students
  end
end

def get_students
  student_num = 1

  if @students.count == 1
    print_cohort_header(@students[0][:cohort])
    print_student(@students[0], student_num)
  else
    @months.each do |month|
      @students.each do |student|
        cohort = student[:cohort]
        if cohort == month[:month] && student_num == 1
          print_cohort_header(cohort)
          print_student(student, student_num)
          student_num += 1
        elsif cohort == month[:month]
          print_student(student, student_num)
          student_num += 1
        end

        if student == @students.last
          student_num = 1
        end
      end
    end
  end
end

def get_next_month(num)
  return @months[num][:month] unless num > 11
end

def print_student(student, number)
  puts "#{number}. #{student[:name]} || DOB: #{student[:birthdate]}".center(100)
end

def print_cohort_header(month)
  puts "-------------".center(100)
  puts " ~ Students in the #{month.capitalize} Cohort ~".center(100)
  puts "-------------".center(100)
end

def print_footer
  add_s = ""
  if !@students.nil?
    add_s = "s" if @students.count != 1
    puts "-------------".center(100)
    puts "Overall, we have #{@students.count} great student#{add_s}".center(100)
  end
end

def interactive_menu
  try_load_students
  loop do
    print_menu
    process(STDIN.gets.chomp)
  end
end

def process(selection)
  case selection
    when "1"
      input_students
    when "2"
      show_students
    when "3"
      try_save_students
    when "4"
      try_load_students
    when "9"
      exit
    else
      puts "I don't know what you meant. Try again."
  end
end

def print_menu
  puts ""
  puts "Choose an option:"
  puts "-------------"
  puts "1. Input the students"
  puts "2. Show the students"
  puts "3. Save your student list"
  puts "4. Load list from a file"
  puts "9. Exit"
  puts ""
end

def show_students
  print_header
  print_students_list
  print_footer
end

def try_load_students
  puts "Which file would you like to load from? Type 'none' if starting from scratch"
  @filename = STDIN.gets.chomp.downcase

  return if @filename == 'none'

  if File.exists?(@filename)
    load_students
    puts "Loaded #{@students.count} from #{@filename}"
  else
    puts "Sorry, #{@filename} doesn't exist."
    exit
  end
end

def load_students
  File.foreach(@filename) do |line|
    name, cohort, birthdate, hobby = line.chomp.split(',')
    add_students(name, cohort, birthdate, hobby)
  end
end

def try_save_students
  puts "Type 'new' to save a few file, or press enter to save to your loaded file."
  file_type = STDIN.gets.chomp

  if file_type == 'new'
    puts "Enter a file name"
    @filename = "#{STDIN.gets.chomp}.csv"
  elsif file_type.empty? && @filename == 'none'
    puts "There is no loaded file. Please enter a filename:"
    @filename = "#{STDIN.gets.chomp}.csv"
  end
  save_students
  puts "#{@students.count} saved to #{@filename}"
end

def save_students
  File.open(@filename, "w") do |file|
    @students.each do |student|
      student_data = [
        student[:name],
        student[:cohort],
        student[:birthdate],
        student[:hobby]
      ]
      file << student_data.join(",")
    end
  end
end

interactive_menu
