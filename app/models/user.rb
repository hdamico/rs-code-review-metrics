# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  login      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  github_id  :bigint           not null
#  node_id    :string           not null
#
# Indexes
#
#  index_users_on_github_id  (github_id) UNIQUE
#
class User < ApplicationRecord
  has_many :owned_review_requests,
           class_name: 'ReviewRequest',
           foreign_key: :owner_id,
           dependent: :destroy,
           inverse_of: :owner
  has_many :received_review_requests,
           class_name: 'ReviewRequest',
           foreign_key: :reviewer_id,
           dependent: :destroy,
           inverse_of: :reviewer
  validates :github_id,
            :login,
            :node_id,
            presence: true
  validates :github_id, uniqueness: true
end