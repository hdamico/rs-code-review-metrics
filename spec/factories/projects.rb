# == Schema Information
#
# Table name: projects
#
#  id          :bigint           not null, primary key
#  description :string
#  is_private  :boolean
#  name        :string
#  relevance   :enum             default("unassigned"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  github_id   :integer          not null
#  language_id :bigint
#
# Indexes
#
#  index_projects_on_language_id  (language_id)
#

FactoryBot.define do
  factory :project do
    sequence(:github_id, 1000)
    name { Faker::App.name.gsub(' ', '') }
    description { Faker::FunnyName.name }
    language { Language.unassigned }
    is_private { false }

    transient do
      last_activity_in_weeks { 2 }
    end

    trait :open_source do
      language { Language.find_by(name: 'ruby') }
      relevance { Project.relevances[:internal] }
      is_private { false }
    end

    trait :with_activity do
      after(:build) do |project, evaluator|
        create(:pull_request, project: project,
                              opened_at: evaluator.last_activity_in_weeks.weeks.ago)
      end
    end

    trait :internal do
      relevance { Project.relevances[:internal] }
    end
  end
end
