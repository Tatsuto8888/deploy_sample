class Board < ApplicationRecord
  belongs_to :user

  validates :amount, presence: true
  validates :body, presence: true

  has_many :comments, dependent: :destroy
  has_many :board_tags, dependent: :destroy
  has_many :tags, through: :board_tags

  def save_tags(tag_names)
    tag_names.each do |name|
      tag = Tag.find_or_create_by(name: name)
      self.tags << tag
    end
  end
end
