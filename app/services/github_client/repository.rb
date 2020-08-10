module GithubClient
  class Repository < GithubClient::Base
    LOCATIONS = %w[.github/CODEOWNERS docs/CODEOWNERS CODEOWNERS].freeze

    def initialize(project)
      @project = project
    end

    def code_owners
      find_in_locations
    end

    def views
      response = connection.get("repositories/#{@project.github_id}/traffic/views") do |request|
        request.params['per'] = 'week'
        request.headers['Accept'] = 'application/vnd.github.v3+json'
      end
      JSON.parse(response.body).with_indifferent_access
    end

    private

    def find_in_locations
      LOCATIONS.each do |location|
        url = "repos/rootstrap/#{@project.name}/contents/#{location}"
        response = connection.get(url) do |request|
          request.headers['Accept'] = 'application/vnd.github.v3.raw'
        end

        return response.body
      rescue Faraday::ResourceNotFound
        next
      end
      ''
    end
  end
end
