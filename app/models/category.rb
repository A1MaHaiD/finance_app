class Category < ApplicationRecord
  belongs_to :user
  has_many :operations, dependent: :destroy

  paginates_per 10
  validates :name, presence: true, uniqueness: {
    scope: :user_id,
    message: "name must be unique within your account"
  }
  validates :description, presence: true

  def destroy_with_operations
    operations.destroy_all
    destroy
  end
end
