class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }

  before_validation { email.downcase! if email.present? }

  before_destroy :ensure_admin_remains
  before_update :ensure_admin_remains_on_update

  private

  def ensure_admin_remains
    if admin? && User.where(admin: true).count == 1
      errors.add(:base, '管理者が0人になるため削除できません')
      throw(:abort)
    end
  end

  def ensure_admin_remains_on_update
    if will_save_change_to_admin? && admin == false && User.where(admin: true).count == 1
      errors.add(:base, '管理者が0人になるため権限を変更できません')
      throw(:abort)
    end
  end
end
