class GithubHandler

  def initialize (event, payload)
    @event = event
    @payload = payload
  end
  def handle
    case @event
    when "pull_request"
      case @payload["action"]
      when "review_requested"
        handle_review_request
        #when "review_request_removed"
        #TODO: Call the method to handle a review request removal
        #else unsupported
      end
      #else unsupported
    end
  end

  def handle_review_request
    owner = User.create_or_find(@payload["pull_request"]["user"])
    participants = []

    #it can either have one or more reviewers requested, and the attribute changes accordingly
    if(@payload["requested_reviews"].nil?) # it is not more than one
      participants << User.create_or_find(@payload["requested_reviewer"])
    else
      @payload["requested_reviewers"].each do |reviewer|
        participants << User.create_or_find(reviewer)
      end
    end 
    #TODO: check the existence of a Review request, and add the users accordingly, instead of duplicating it
    #The PR association is probably necessary for this
    rev_req = ReviewRequest.create(data: @payload, owner: owner, users: participants)

  end

end
