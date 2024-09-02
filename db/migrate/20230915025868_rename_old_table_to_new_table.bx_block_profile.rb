# This migration comes from bx_block_profile (originally 20230316093309)
class RenameOldTableToNewTable < ActiveRecord::Migration[6.0]
  def self.up
    rename_table :custom_user_profile_fields, :bx_block_profile_custom_user_profile_fields
    rename_table :associateds, :bx_block_profile_associateds
    rename_table :associated_projects, :bx_block_profile_associated_projects
    rename_table :awards, :bx_block_profile_awards
    rename_table :career_experiences, :bx_block_profile_career_experiences
    rename_table :career_experience_industry, :bx_block_profile_career_experience_industry
    rename_table :courses, :bx_block_profile_courses
    rename_table :career_experience_system_experiences, :bx_block_profile_career_experience_system_experiences
    rename_table :current_annual_salaries, :bx_block_profile_current_annual_salaries
    rename_table :current_annual_salary_current_status, :bx_block_profile_current_annual_salary_current_status
    rename_table :current_status, :bx_block_profile_current_status
    rename_table :current_status_employment_types, :bx_block_profile_current_status_employment_types
    rename_table :current_status_industries, :bx_block_profile_current_status_industries
    rename_table :degrees, :bx_block_profile_degrees
    rename_table :degree_educational_qualifications, :bx_block_profile_degree_educational_qualifications
    rename_table :educational_qualifications, :bx_block_profile_educational_qualifications
    rename_table :educational_qualification_field_study, :bx_block_profile_educational_qualification_field_study
    rename_table :employment_types, :bx_block_profile_employment_types
    rename_table :field_study, :bx_block_profile_field_study
    rename_table :hobbies_and_interests, :bx_block_profile_hobbies_and_interests
    rename_table :industries, :bx_block_profile_industries
    rename_table :languages, :bx_block_profile_languages
    rename_table :projects, :bx_block_profile_projects
    rename_table :publication_patents, :bx_block_profile_publication_patents
    rename_table :system_experiences, :bx_block_profile_system_experiences
    rename_table :test_score_and_courses, :bx_block_profile_test_score_and_courses
    rename_table :career_experience_employment_types, :bx_block_profile_career_experience_employment_types
  end

  def self.down
    rename_table :bx_block_profile_custom_user_profile_fields ,  :custom_user_profile_fields
    rename_table :bx_block_profile_associateds ,  :associateds
    rename_table :bx_block_profile_associated_projects, :associated_projects
    rename_table :bx_block_profile_awards , :awards
    rename_table :bx_block_profile_career_experiences, :career_experiences
    rename_table :bx_block_profile_career_experience_industry,  :career_experience_industry
    rename_table :bx_block_profile_courses, :courses
    rename_table :bx_block_profile_career_experience_system_experiences, :career_experience_system_experiences
    rename_table :bx_block_profile_current_annual_salaries, :current_annual_salaries
    rename_table :bx_block_profile_current_annual_salary_current_status, :current_annual_salary_current_status
    rename_table :bx_block_profile_current_status, :current_status
    rename_table :bx_block_profile_current_status_employment_types, :current_status_employment_types
    rename_table :bx_block_profile_current_status_industries,  :current_status_industries
    rename_table :bx_block_profile_degrees, :degrees
    rename_table :bx_block_profile_degree_educational_qualifications,  :degree_educational_qualifications
    rename_table :bx_block_profile_educational_qualifications, :educational_qualifications
    rename_table :bx_block_profile_educational_qualification_field_study, :educational_qualification_field_study
    rename_table :bx_block_profile_employment_types, :employment_types
    rename_table :bx_block_profile_field_study, :field_study
    rename_table :bx_block_profile_hobbies_and_interests,  :hobbies_and_interests
    rename_table :bx_block_profile_industries, :industries
    rename_table :bx_block_profile_languages,  :languages
    rename_table :bx_block_profile_projects, :projects
    rename_table :bx_block_profile_publication_patents, :publication_patents
    rename_table :bx_block_profile_system_experiences, :system_experiences
    rename_table :bx_block_profile_test_score_and_courses,  :test_score_and_courses
    rename_table :bx_block_profile_career_experience_employment_types, :career_experience_employment_types
  end
end
