class Restaurant < ApplicationRecord
    has_secure_password
    validates :email, email: true
end
