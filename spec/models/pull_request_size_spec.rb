# == Schema Information
#
# Table name: pull_request_sizes
#
#  id              :bigint           not null, primary key
#  value           :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  pull_request_id :bigint           not null
#
# Indexes
#
#  index_pull_request_sizes_on_pull_request_id  (pull_request_id)
#
# Foreign Keys
#
#  fk_rails_...  (pull_request_id => pull_requests.id)
#

require 'rails_helper'

RSpec.describe PullRequestSize, type: :model do
  subject { build :pull_request_size }

  context 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without value' do
      subject.value = nil
      expect(subject).to_not be_valid
    end

    it { is_expected.to validate_uniqueness_of(:pull_request_id) }
    it { is_expected.to belong_to(:pull_request) }
  end
end