require 'rails_helper'

RSpec.describe Processors::PullRequestSizeUpdater do
  describe '.call' do
    let!(:pull_request) { create(:pull_request) }
    let(:pull_request_file_payload) { create(:pull_request_file_payload) }
    let(:pr_size_value) { pull_request_file_payload['additions'] }

    before { stub_pull_request_files_with_pr(pull_request, [pull_request_file_payload]) }

    it 'creates or updates the pull request size metric of all pull requests' do
      described_class.call

      expect(pull_request.pull_request_size.value).to eq(pr_size_value)
    end

    context 'when a pull request file request fails' do
      let!(:failing_pull_request) { create(:pull_request) }
      let!(:successful_pull_request) { create(:pull_request) }

      before do
        stub_failed_pull_request_files(failing_pull_request)
        stub_pull_request_files_with_pr(successful_pull_request)
      end

      it 'finishes processing all other pull requests' do
        expect { described_class.call }.to change { PullRequestSize.count }.by(2)
      end
    end
  end
end
