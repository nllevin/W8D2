require 'securerandom'

class ShortenedUrl < ApplicationRecord
  validates :short_url, presence: true, uniqueness: true
  validates :long_url, presence: true
  validates :user_id, presence: true

  def self.random_code
    loop do
      code = SecureRandom.urlsafe_base64
      return code unless ShortenedUrl.exists?(:short_url => code)
    end
  end

  def self.create!(user, long_url)
    ShortenedUrl.create(short_url: self.random_code, long_url: long_url, user_id: user.id)
  end

  belongs_to :submitter,
    class_name: 'User',
    primary_key: :id,
    foreign_key: :user_id

  
end