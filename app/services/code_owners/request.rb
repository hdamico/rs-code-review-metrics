module CodeOwners
  class Request < BaseService
    def call
      Project.find_each do |project|
        content_file = GithubClient::Repository.new(project).code_owners
        next if content_file.empty?

        code_owners = CodeOwners::FileHandler.call(content_file)
        CodeOwners::ProjectHandler.call(project, code_owners)
      end
    end
  end
end
