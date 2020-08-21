require 'yaml'

ALL_LANGS = YAML.load_file('calculator_messages.yml')
DEFAULT_LANGUAGE = "english"

def clear_screen
  system("clear") || system("cls")
end

def messages(lang=DEFAULT_LANGUAGE)
  ALL_LANGS[lang]
end

# assign language name to change program language
# default language is "english"
# available languages "english" and "turkish"
# MESSAGES = messsage "turkish"
MESSAGES = messages

def prompt(key)
  puts "=> #{key}"
end

def integer?(input)
  /^\d+$/.match(input)
end

def float?(input)
  /\d/.match(input) && /^\d*\.?\d*$/.match(input)
end

def number?(num)
  integer?(num) || float?(num)
end

def valid_name?(name)
  name.strip.empty? != true
end

def retrieve_name
  loop do
    prompt(MESSAGES['prompt_name'])
    name = gets.chomp
    break name.strip if valid_name?(name)
    prompt(MESSAGES['valid_name'])
  end
end

def retrieve_number(which_number)
  loop do
    prompt(MESSAGES[which_number])
    number = gets.chomp

    break number if number?(number)
    prompt(MESSAGES['valid_number'])
  end
end

def retrieve_operator
  loop do
    prompt(MESSAGES['operator_prompt'])
    operator = gets.chomp

    break operator if %w(1 2 3 4).include?(operator)
    prompt(MESSAGES['valid_operator'])
  end
end

def retrieve_new_calc_answer
  loop do
    prompt(MESSAGES['another_calc'])
    answer = gets.chomp.downcase
    break answer if %w(y yes n no).include?(answer)
    prompt(MESSAGES['valid_another'])
  end
end

def new_calculation?(answer)
  %w(y yes).include?(answer)
end

def calculate(op, num1, num2)
  num1 = num1.to_f
  num2 = num2.to_f
  result = case op
           when '1' then num1 + num2
           when '2' then num1 - num2
           when '3' then num1 * num2
           when '4' then num1 / num2
           end
  result
end

clear_screen
first_calculation = true
prompt(MESSAGES['welcome'])

name = retrieve_name
prompt("#{MESSAGES['hi']} #{name}!")

loop do # main loop
  clear_screen unless first_calculation
  number1 = retrieve_number("first")
  number2 = retrieve_number("second")
  operator = retrieve_operator

  prompt(MESSAGES[operator])

  result = calculate(operator, number1, number2)

  if result.finite?
    prompt("#{MESSAGES['result']} #{result}")
  else
    prompt(MESSAGES['zero_div'])
  end

  answer = retrieve_new_calc_answer
  break unless new_calculation?(answer)

  first_calculation = false
end

prompt(MESSAGES['goodbye'])
