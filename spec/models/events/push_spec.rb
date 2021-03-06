# == Schema Information
#
# Table name: pushes
#
#  id              :bigint           not null, primary key
#  ref             :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  project_id      :bigint           not null
#  pull_request_id :bigint
#  sender_id       :bigint           not null
#
# Indexes
#
#  index_pushes_on_project_id       (project_id)
#  index_pushes_on_pull_request_id  (pull_request_id)
#  index_pushes_on_sender_id        (sender_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#  fk_rails_...  (pull_request_id => pull_requests.id)
#  fk_rails_...  (sender_id => users.id)
#

require 'rails_helper'

RSpec.describe Events::Push, type: :model do
  context 'validations' do
    subject { build(:push) }

    it { is_expected.to have_one(:event) }
    it { is_expected.to belong_to(:sender) }
    it { is_expected.to belong_to(:project) }

    it 'is valid without a pull request' do
      subject.pull_request = nil
      expect(subject).to be_valid
    end
  end
end
