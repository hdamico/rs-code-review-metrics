# == Schema Information
#
# Table name: blog_posts
#
#  id           :bigint           not null, primary key
#  published_at :datetime
#  slug         :string
#  status       :string
#  url          :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  blog_id      :integer
#
class BlogPost < ApplicationRecord
  enum status: {
    publish: 'publish',
    draft: 'draft',
    pending: 'pending',
    non_public: 'private',
    future: 'future',
    trash: 'trash',
    auto_draft: 'auto-draft'
  }

  has_many :blog_post_technologies, dependent: :destroy
  has_many :technologies, through: :blog_post_technologies

  validates :blog_id, uniqueness: true
  validates :status, inclusion: { in: statuses.keys }
end
