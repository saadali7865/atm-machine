require 'csv'
require_relative 'utils.rb'
include AccountsDatabase, AccountDetail

class Account
  STATUS = { active: "active", inactive: "in active" }.freeze
  TYPE = { admin: "admin", public: "public" }.freeze

  attr_accessor :id, :user_id, :pin, :status, :type, :created_at

  def initialize(id, user_id, pin, status=:active, type=:public, created_at=Time.now)
    @id = id
    @user_id = user_id
    @pin = pin
    @type = type
    @status = status
    @created_at = created_at
  end

end

class AccountController
  @@accounts = []
  def initialize(user_controller)
    @@accounts = AccountController.load_accounts
    @user_controller = user_controller
  end

  def self.load_accounts
    accounts = []
    CSV.foreach(ACCOUNTS, headers: true) do |row|
      accounts << Account.new(row['id'], row['user'], row['pin'], row['type'], row['status'], row['created_at'])
    end
    accounts
  end

  def self.save_accounts
    headers = [ID, USER, PIN, TYPE, STATUS, STATUS, CREATED_AT]
    CSV.open(ACCOUNTS, 'w', write_headers: true, headers: headers) do |csv|
      @@accounts.each do |account|
        csv << [account.id, account.user_id, account.pin, account.type, account.status, account.created_at]
      end
    end
  end

  def create_account(user_id, pin)
    user = @user_controller.get_user(user_id)
    if user
      id = @@accounts.length + 1
      account = Account.new(id, user_id, pin)
      @@accounts.append(account)
      "Account created successfully"
    else
      "No user found"
    end

  end
end

class AccountBalance

  attr_accessor :id, :account_id, :balance, :created_at

  def initialize(id, account_id, balance)
    @id = id
    @account_id = account_id
    @balance = balance
    @created_at = Time.now
  end

end
