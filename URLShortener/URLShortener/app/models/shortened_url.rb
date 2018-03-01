# == Schema Information
#
# Table name: shortened_urls
#
#  id         :integer          not null, primary key
#  short_url  :string
#  long_url   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id     :integer

class ShortenedUrl < ApplicationRecord
  include SecureRandom

  validates :short_url, presence: true, uniqueness: true
  validates :long_url, presence: true
  validates :user_id, presence: true

  belongs_to :submitter,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  has_many :visits,
    primary_key: :id,
    foreign_key: :url_id,
    class_name: :Visit

  has_many :visitors,
    through: :visits,
    source: :visitor

  def self.random_code

    string = SecureRandom.urlsafe_base64(12)
    p string.length
    string
  end

  def self.generate_short_url(user, long_url)
    short_url = ShortenedUrl.random_code
    ShortenedUrl.create!(user_id: user.id, long_url: long_url, short_url: short_url)
  end

  def num_clicks
    visitors.count
  end

  def num_uniques
    visitors.uniq.count
  end

  def num_recent_uniques
    #returns any visits that have happened within the past 10 minutes
    visits.where('created_at > ?', 10.minutes.ago).uniq.count
  end
end
