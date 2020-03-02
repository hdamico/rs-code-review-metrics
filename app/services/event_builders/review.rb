module EventBuilders
  class Review < EventBuilder
    def build
      review_data = @payload['review']
      Events::Review.find_or_create_by!(github_id: review_data['id']) do |rc|
        rc.owner = find_or_create_user(review_data['user'])
        rc.pull_request = find_pull_request
      end
    end
  end
end