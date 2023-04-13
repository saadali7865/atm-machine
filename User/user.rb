require 'csv'
require_relative 'utils.rb'

class User
  STATUS = { active: "active", inactive: "in active" }.freeze
  TYPE = { admin: "admin", public: "public" }.freeze

  attr_accessor :id, :name, :national_id, :address, :password, :status, :type,:created_at

  def initialize(id, name, address, national_id, password, status=:active, type=:public, created_at=Time.now)
    @id = id
    @address = address
    @name = name
    @national_id = national_id
    @password = password
    @status = status
    @type=type
    @created_at = created_at
  end

end

class UserController
  include UsersDatabase, UserDetail
  def initialize
    load_users
  end

  def login(name, password)
    @@users.find { |user| user.name == name and user.password == password}
  end

  def self.save_users
    headers = [ID, NAME, ADDRESS, NATIONAL_ID, PASSWORD, STATUS, TYPE,CREATED_AT]
    CSV.open(USERS, 'w', write_headers: true, headers: headers) do |csv|
      @@users.each do |user|
        csv << [user.id, user.name, user.address, user.national_id, user.password, user.status, user.type, user.created_at]
      end
    end
  end

  def create_user(name, address, national_id, password)
    id = @@users.length + 1
    user = User.new(id, name, address, national_id, password)
    @@users.append(user)
    "User created successfully"
  end

  def edit_user(user_id, name, address, national_id, password)
    user = get_user(user_id)
    if user
      user.name=name
      user.address = address
      user.national_id=national_id
      user.password=password
      "User updated successfully"
    else
      "User not found"
    end
  end

  def delete_user(user_id)
    user = get_user(user_id)
    if user
      user.status = :inactive
      "User deleted successfully"
    else
      "User not found"
    end
  end

  def get_user(user_id)
    @@users.find { |user| user.id == user_id}
  end

  private
  def load_users
    @@users ||= begin
                  CSV.foreach(USERS, headers: true).map do |row|
                    User.new(row['id'], row['name'], row['address'], row['national_id'], row['password'], row['status'], row['type'], row['created_at'])
                  end
                end
  end


end
