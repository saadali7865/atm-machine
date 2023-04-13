require_relative '../Account/account'
require_relative '../User/user'
class Simulator

  def initialize
    @user_controller = UserController.new
    @account_controller = AccountController.new(@user_controller)

  end

  def login
    puts "ATM Simulator!"
    puts "Please login to your account"
    puts "Please enter your name:"
    name = gets.chomp
    puts "Please enter your password:"
    password = gets.chomp
    @user_controller.login(name, password)
  end
  def start(user)
    if user.type == "admin"
      loop do
        puts "Please select an option:"
        puts "1. Create User"
        puts "2. Edit User"
        puts "3. Delete User"
        puts "4. Create User account"
        puts "5. Exit"
        choice = gets.chomp.to_i

        case choice
        when 1
          puts create_user
        when 2
          puts edit_user
        when 3
          puts delete_user
        when 4
          puts create_user_account
        when 5
          stop
          break
        else
          puts "Invalid choice. Please try again."
        end
      end
      puts "Thank you for using ATM!"

    else
      loop do
        puts "Please select an option:"
        puts "1. Make a transaction"
        puts "2. Exit"
        choice = gets.chomp.to_i

        case choice
        when 1
          puts make_a_transaction(user)
        when 2
          stop
          break
        else
          puts "Invalid choice. Please try again."
        end
      end
      puts "Thank you for using ATM!"
    end

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

  def edit_user
    puts "Please enter the user's id:"
    id = gets.chomp

    puts "Please enter the user's name:"
    name = gets.chomp

    puts "Please enter the user's address:"
    address = gets.chomp

    puts "Please enter the user's national id:"
    national_id = gets.chomp

    puts "Please enter the user's password:"
    password = gets.chomp

    @user_controller.edit_user(id, name, address, national_id, password)

  end

  def delete_user
    puts "Please enter the user's id:"
    id = gets.chomp

    @user_controller.delete_user(id)
  end

  def create_user_account
    puts "Please enter user id, for which you want to create account:"
    user_id = gets.chomp

    puts "Please enter 4-digit pin code:"
    pin = gets.chomp

    @account_controller.create_account(user_id, pin)

  end

  def make_a_transaction(user)
    account_id = @account_controller.get_user_account(user.id).id

    puts "Please enter balance"
    balance = gets.chomp

    @account_controller.make_a_transaction(account_id, balance)

  end

  def stop
    UserController.save_users
    AccountController.save_accounts
  end
end

simulator = Simulator.new
user = simulator.login
if user
  simulator.start(user)
else
  puts "Authentication failed. Please try again"
end

