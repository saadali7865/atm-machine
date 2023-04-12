require 'csv'
require_relative 'utils.rb'
include UsersDatabase, UserDetail, UserStatus

class User
  attr_accessor :id, :name, :national_id, :address, :status, :created_at

  def initialize(name, address, national_id, password)
    @address = address
    @id = get_users_count + 1
    @name = name
    @national_id = national_id
    @password = password
    @status = ACTIVE
    @created_at = Time.now
  end

  def get_users_count
      CSV.read(USERS).size - 1
  end

  def create_user
    CSV.open(USERS, 'a') do |csv|
      csv << [@id, @name, @address, @national_id, @password, @status, @created_at]
    end
  end

  def get_user
     {ID: @id, NAME: @name, ADDRESS: @address, NATIONAL_ID: @national_id, PASSWORD: @password, STATUS: @status, CREATED_AT: @created_at}
  end

end

