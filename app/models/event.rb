class Event < ApplicationRecord

  belongs_to :host, class_name: "User"
  has_many :guests, class_name: "User"

  mount_uploader :picture, PictureUploader

  validates :title, presence: true, length: {minimum: 3, maximum: 150}
  validates :body, presence:true ,length: { minimum: 25, maximum: 2500}
  validates :location, presence:true, length:{ minimum: 3 , maximum: 100}
  validates :date, presence:true

  def add_guest(user)
    self.guests << user
  end

  def remove_guest(user)
    self.guests.delete(user)
  end
end
