require_relative '../Account/account'
require_relative '../User/user'
class Simulator

  def initialize
    @user_controller = UserController.new
    @account_controller = AccountController.new(@user_controller)

  end
  def start
    puts "ATM Simulator!"
    loop do
      puts "Please select an option:"
      puts "1. Create User"
      puts "2. Create User account"
      puts "3. Exit"
      choice = gets.chomp.to_i

      case choice
      when 1
        puts create_user
      when 2
        puts create_user_account
      when 3
        stop
        break
      else
        puts "Invalid choice. Please try again."
      end
    end
    puts "Thank you for using ATM!"
  end

  def create_user
    puts "Please enter the user's name:"
    name = gets.chomp

    puts "Please enter the user's address:"
    address = gets.chomp

    puts "Please enter the user's national id:"
    national_id = gets.chomp

    puts "Please enter the user's password:"
    password = gets.chomp

    @user_controller.create_user(name, address, national_id, password)

  end

  def create_user_account
    puts "Please enter user id, for which you want to create account:"
    user_id = gets.chomp

    puts "Please enter 4-digit pin code:"
    pin = gets.chomp

    @account_controller.create_account(user_id, pin)

  end

  def stop
    UserController.save_users
    AccountController.save_accounts
  end
end

simulator = Simulator.new
simulator.start

