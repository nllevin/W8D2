# == Schema Information
#
# Table name: shortened_urls
#
#  id         :bigint           not null, primary key
#  short_url  :string           not null
#  long_url   :string           not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

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

  has_many :visits,
    class_name: 'Visit',
    primary_key: :id,
    foreign_key: :url_id

  has_many :visitors,
    -> { distinct },
    through: :visits,
    source: :visitor

  def num_clicks
    self.visits.count
  end

  def num_uniques
    self.visitors.count
  end

  def num_recent_uniques
    self.visits.select(:visitor_id).distinct.where(created_at: 10.minutes.ago..Time.now).count
  end
end 
