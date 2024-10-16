class Badge < ApplicationRecord
  belongs_to :user
  validates :name, presence: true
  validates :image_url, presence: true
  validate :allow_blank_name


  def self.first_connection
    new(name: "1ª Conexão", image_url: "first_connection_badge.png")

  end

  def self.mentor_ativo
    new(name: "Mentor Ativo", image_url: "mentor_ativo_badge.png")
  end
end

private

def allow_blank_name
  if name.blank? && image_url.present?
    errors.add(:name, "can't be blank")
  end
end
