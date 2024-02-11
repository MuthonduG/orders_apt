class Restaurant < ApplicationRecord
    has_secure_password
    has_many :dishes
    validates :email, email: true
end
