# == Schema Information
#
# Table name: reviews
#
#  id              :bigint           not null, primary key
#  body            :string
#  status          :enum             default("active")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  github_id       :integer
#  owner_id        :bigint
#  pull_request_id :bigint           not null
#
# Indexes
#
#  index_reviews_on_owner_id         (owner_id)
#  index_reviews_on_pull_request_id  (pull_request_id)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#  fk_rails_...  (pull_request_id => pull_requests.id)
#

require 'rails_helper'

RSpec.describe Events::Review, type: :model do
  describe 'validations' do
    subject { build :review }

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without github id' do
      subject.github_id = nil
      expect(subject).to_not be_valid
    end

    it { is_expected.to belong_to(:pull_request) }
  end
end