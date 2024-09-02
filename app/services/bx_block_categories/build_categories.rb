# frozen_string_literal: true

module BxBlockCategories
  class BuildCategories
    class << self
      CATEGORIES_AND_SUB_CATEGORIES_HASH = {
        "K12" => [
          "Pre Primary (kg)",
          "Primary (1 to 5)",
          "Middle (6 to 8)",
          "Secondary (9 & 10)",
          "Senior Secondary (11 & 12)"
        ],
        "Higher Education" => [
          "Accounting & Commerce",
          "Animation",
          "Architecture & Alanning",
          "Arts (Fine/Visual/Performing)",
          "Aviation",
          "Banking, Finance & Insurance",
          "Beauty & Fitness",
          "Business & Management Studies",
          "Design",
          "Engineering",
          "Hospitality & Travel",
          "Humanities & Social Sciences",
          "IT & Software",
          "Law",
          "Mass Communication & Media",
          "Medicine & Health Sciences",
          "Nursing",
          "Science",
          "Teaching & Education"
        ],
        "Govt Job" => [
          "Banking",
          "Railways",
          "Defense",
          "Police",
          "UGC NET",
          "Teaching",
          "SSC",
          "UPSC",
          "State PSCs",
          "Judiciary"
        ],
        "Competitive Exams" => %w[
          JEE
          NEET
          CLAT
        ],
        "Upskilling" => []
      }.freeze

      def call(categories_and_sub_categories = CATEGORIES_AND_SUB_CATEGORIES_HASH)
        categories_and_sub_categories.each do |key, value|
          category = BxBlockCategories::Category.where(
            "lower(name) = ?", key.downcase
          ).first_or_create(name: key, identifier: category_identifier_hash[key])
          category.update(identifier: category_identifier_hash[key])
          value.each do |val|
            category.sub_categories.where(
              "lower(name) = ?", val.downcase
            ).first_or_create(name: val, categories: [category])
          end
        end
      end

      private

      def category_identifier_hash
        {
          "K12" => "k12",
          "Higher Education" => "higher_education",
          "Govt Job" => "govt_job",
          "Competitive Exams" => "competitive_exams",
          "Upskilling" => "upskilling"
        }
      end
    end
  end
end
