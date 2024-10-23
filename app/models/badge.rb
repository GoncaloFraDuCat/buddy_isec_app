class Badge < ApplicationRecord
  belongs_to :user
  validates :name, presence: true
  validates :image_url, presence: true
  validate :allow_blank_name


  Badges = {
    mentor_ativo: {
      name: "Mentor Ativo",
      image_url: "mentor_ativo_badge.png"
  },
    first_connection: {
      name: "1ª Conexão",
      image_url: "first_connection_badge.png"
    }
  }

  #?#  def self.first_connection
  #?#    new(name: "1ª Conexão", image_url: "first_connection_badge.png")
  #?#
  #?#  end

  #?#  def self.mentor_ativo
  #?#    new(name: "Mentor Ativo", image_url: "mentor_ativo_badge.png")
  #?#  end



    def award_badge!(badge_name)
      return if badges.pluck(:name).include?(badge_name)

      Badge.create!(user: self, name: badge_name, image_url: "#{badge_name}.png")
    end

    def remove_badge!(badge_name)
      badge = badges.find_by(name: badge_name)
      badge.destroy if badge.present?
    end

    def has_badge?(badge_name)
      badges.pluck(:name).include?(badge_name)
    end


end

private

def allow_blank_name
  if name.blank? && image_url.present?
    errors.add(:name, "can't be blank")
  end
end
