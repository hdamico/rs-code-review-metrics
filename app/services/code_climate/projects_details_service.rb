module CodeClimate
  class ProjectsDetailsService < BaseService
    attr_reader :department, :from, :technologies

    def initialize(department:, from:, technologies: [])
      @department = department
      @from = from
      @technologies = technologies
    end

    def call
      build_summary
    end

    private

    def build_summary
      return ProjectsSummary.new unless metrics?

      code_climate_metrics.map do |metric|
        ProjectSummary.new(rate: metric.code_climate_rate,
                            invalid_issues_count: metric.invalid_issues_count,
                            open_issues_count: metric.open_issues_count,
                            wont_fix_issues_count: metric.wont_fix_issues_count,
                            snapshot_time: metric.snapshot_time)
      end
    end

    def metrics?
      !code_climate_metrics.empty?
    end

    def code_climate_metrics
      @code_climate_metrics ||= metrics_in_given_technologies
    end

    def metrics_in_given_technologies
      if technologies.empty?
        metrics_in_time_period
      else
        metrics_in_time_period.where('languages.name IN (?)', technologies)
      end
    end

    def metrics_in_time_period
      if from
        metrics_in_department.where('snapshot_time >= ?', from)
      else
        metrics_in_department
      end
    end

    def metrics_in_department
      CodeClimateProjectMetric
        .joins(project: { language: :department })
        .where(departments: { id: department.id })
    end
  end
end
