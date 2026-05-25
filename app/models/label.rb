class Label < ApplicationRecord
  belongs_to :user

  has_many :labellings, dependent: :destroy
  has_many :tasks, through: :labellings

  validates :name, presence: true

  def self.human_attribute_name(attr, options = {})
    if attr == :name
      '名前'
    else
      super
    end
  end
end
