class Operation < ApplicationRecord
  belongs_to :category

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :operation_type, presence: true
  validates :odate, presence: true
  validates :description, presence: true
end
