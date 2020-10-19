require 'rails_helper'

RSpec.describe Processors::External::PullRequests do
  let(:user) { create(:user, login: 'hvilloria') }

  let!(:pull_requests_events_payload) do
    [create(:github_api_client_pull_request_event_payload, username: user.login)]
  end

  before do
    stub_get_pull_requests_events(user.login, pull_requests_events_payload)
  end

  context 'when user has pull request in a given project' do
    it 'saves given project' do
      expect { described_class.call(user.login) }
        .to change { ExternalProject.count }.by(1)
    end

    it 'saves pull requests where the username is owner' do
      expect { described_class.call(user.login) }
        .to change { ExternalPullRequest.count }.by(1)
    end
  end
end
