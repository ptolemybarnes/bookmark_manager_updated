require 'bcrypt'

class User
  include DataMapper::Resource

  property :id, Serial
  property :email, String
  property :password_digest, Text

  validates_confirmation_of :password

  attr_reader :password
  attr_accessor :password_confirmation # NOTE: Never create an accessor with the same name as a DataMapper property

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end
end
