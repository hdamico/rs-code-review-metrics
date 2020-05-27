class ProjectsController < ApplicationController
  def user_project_metric
    if valid_params?
      period = params[:period]
      if period.present?
        @metrics = Queries::BaseQueryMetric.determinate_metric_period(period).call(
          project_id: project_id,
          metric_name: params[:metric_type]
        )
      end
    else
      not_found
    end
  end

  private

  def project_id
    @project_id ||= Project.find_by(name: params[:name])
  end

  def valid_params?
    Metric.names.include?(params[:metric_type])
  end
end
