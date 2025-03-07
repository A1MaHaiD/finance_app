class Category < ApplicationRecord
    has_many :operations, dependent: :destroy

    paginates_per 10
    validates :name, presence: true, uniqueness: true
    validates :description, presence: true
end
