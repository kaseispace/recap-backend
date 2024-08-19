class User < ApplicationRecord
    has_many :user_schools, dependent: :destroy
    has_many :schools, through: :user_schools

    validates :uid, presence: true, uniqueness: true
    validates :name, presence: true
    validates :user_type, presence: true
end
