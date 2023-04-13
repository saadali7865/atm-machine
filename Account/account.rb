require 'csv'
require_relative 'utils.rb'

class Account
  STATUS = { active: "active", inactive: "in active" }.freeze

  attr_accessor :id, :user_id, :pin, :status, :balance, :created_at

  def initialize(id, user_id, pin, balance, status=:active, created_at=Time.now)
    @id = id
    @user_id = user_id
    @pin = pin
    @balance = balance
    @status = status
    @created_at = created_at
  end

end

class AccountController
  include AccountsDatabase, AccountDetail
  def initialize(user_controller)
    load_accounts
    @user_controller = user_controller
  end

  def self.save_accounts
    headers = [ID, USER, PIN, BALANCE, STATUS, STATUS, CREATED_AT]
    CSV.open(ACCOUNTS, 'w', write_headers: true, headers: headers) do |csv|
      @@accounts.each do |account|
        csv << [account.id, account.user_id, account.pin, account.balance, account.status, account.created_at]
      end
    end
  end

  def create_account(user_id, pin)
    user = @user_controller.get_user(user_id)
    if user
      id = @@accounts.length + 1
      account = Account.new(id, user_id, pin, 0)
      @@accounts.append(account)
      "Account created successfully"
    else
      "No user found"
    end

  end

  def get_account(account_id)
    @@accounts.find { |account| account.id == account_id}
  end

  def get_user_account(user_id)
    @@accounts.find { |account| account.user_id == user_id}
  end

  def make_a_transaction(account_id, balance)
    account = @@accounts.find { |record| record.id == account_id }
    if account
      account.balance = account.balance.to_i + balance.to_i
      "Transaction completed"
    else
      "Account not found"
    end
  end

  private
  def load_accounts
    @@accounts ||= begin
                     CSV.foreach(ACCOUNTS, headers: true).map do |row|
                       Account.new(row[ID], row[USER], row[PIN], row[BALANCE], row[STATUS], row[CREATED_AT])
                     end
                   end
  end

end