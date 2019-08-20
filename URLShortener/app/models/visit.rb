# == Schema Information
#
# Table name: visits
#
#  id         :bigint           not null, primary key
#  visitor_id :integer          not null
#  url_id     :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Visit < ApplicationRecord
  validates :visitor_id, presence: true
  validates :url_id, presence: true

  def self.record_visit!(user, shortened_url)
    Visit.create(visitor_id: user.id, url_id: shortened_url.id)
  end

  belongs_to :visitor,
    class_name: 'User',
    primary_key: :id,
    foreign_key: :visitor_id

  belongs_to :visited_url,
    class_name: 'ShortenedUrl',
    primary_key: :id,
    foreign_key: :url_id
end
