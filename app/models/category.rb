class Category < ApplicationRecord
    has_many :operations, dependent: :destroy

    paginates_per 10
    validates :name, presence: true, uniqueness: true
    validates :description, presence: true

    before_destroy :check_for_operations

    private

    def check_for_operations
        if operations.exists?
            errors.add(:base, 'Неможливо видалити категорію, поки існують пов’язані операції.')
            throw :abort
        end
    end
end
