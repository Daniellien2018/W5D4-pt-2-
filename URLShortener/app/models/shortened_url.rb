# == Schema Information
#
# Table name: shortened_urls
#
#  id         :bigint           not null, primary key
#  long_url   :string           not null
#  short_url  :string           not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ShortenedUrl < ApplicationRecord
    validates :long_url, :short_url, presence: true
    validates :short_url, uniqueness: true
    after_initialize :generate_short_url, if: :new_record?

    def self.random_code
        short_url = SecureRandom.urlsafe_base64
        until self.all.exist?(short_url)
            short_url = SecureRandom.urlsafe_base64
        end
        short_url
    end

    private
    def generate_short_url
        self.short_url = ShortenedUrl.random_code if self.short_url.nil?
    end 

    has_many :submitter
        primary_key: :id
        foreign_key: :user_id
        class_name: :User

    

end
