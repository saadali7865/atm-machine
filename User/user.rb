require 'csv'
require_relative 'utils.rb'
include UsersDatabase, UserDetail

class User
  STATUS = { active: "active", inactive: "in active" }.freeze

  attr_accessor :id, :name, :national_id, :address, :password, :status, :created_at

  def initialize(id, name, address, national_id, password)
    @id = id
    @address = address
    @name = name
    @national_id = national_id
    @password = password
    @status = :active
    @created_at = Time.now
  end

  def self.load_users
    users = []
    CSV.foreach(USERS, headers: true) do |row|
      users << User.new(row['id'], row['name'], row['address'], row['national_id'], row['password'])
    end
    users
  end

  def self.save_users(users)
    headers = [ID, NAME, ADDRESS, NATIONAL_ID, PASSWORD, STATUS, CREATED_AT]
    CSV.open(USERS, 'w', write_headers: true, headers: headers) do |csv|
      users.each do |user|
        csv << [user.id, user.name, user.address, user.national_id, user.password, user.status, user.created_at]
      end
    end
  end

  def create_user(id, name, address, national_id, password)
     User.new(id, name, address, national_id, password)
  end

  def get_user(users, user_id)
    users.each do |user|
      return user if user.id == user_id
    end
     nil
  end

end
