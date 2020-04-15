module Processors
  class ReviewTurnaround < BaseService
    ENTITIES = ["UserProject"]

    def call
      process
    end

    private

    def process
      ENTITIES.each do |entity|
        Metrics::ReviewTurnaround.const_get("Per#{entity}").call
      end
    end
  end
end