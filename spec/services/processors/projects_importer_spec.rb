require 'rails_helper'

RSpec.describe Processors::ProjectsImporter do
  describe '.call' do
    let(:repository_payload) { create(:repository_payload) }

    before { stub_organization_repositories([repository_payload]) }

    it 'successfully imports the project' do
      described_class.call

      imported_project = Project.find_by(github_id: repository_payload['id'])
      expect(imported_project.name).to eq repository_payload['name']
      expect(imported_project.description).to eq repository_payload['description']
      expect(imported_project.is_private).to eq repository_payload['private']
    end

    context 'when the project is new' do
      it 'creates a new project' do
        expect { described_class.call }.to change(Project, :count).by 1
      end
    end

    context 'when the project has already been imported' do
      before { create(:project, github_id: repository_payload['id']) }

      it 'does not create a new one' do
        expect { described_class.call }.not_to change(Project, :count)
      end
    end
  end
end
