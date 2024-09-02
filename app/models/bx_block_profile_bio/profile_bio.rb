# frozen_string_literal: true

# rubocop:disable Naming/VariableNumber, Lint/IneffectiveAccessModifier, Metrics/AbcSize, Naming/MemoizedInstanceVariableName, Metrics/MethodLength, Lint/UselessAssignment, Metrics/ClassLength, Style/GlobalVars
module BxBlockProfileBio
  # profile bio model
  class ProfileBio < BxBlockProfileBio::ApplicationRecord
    self.table_name = :profile_bios

    belongs_to :account, class_name: 'AccountBlock::Account'

    has_many :educations, dependent: :destroy
    has_many :achievements, dependent: :destroy
    has_many :careers, dependent: :destroy

    enum marital_status: %i[Single In-Relationship Engaged Married Divorced Widowed], _prefix: :marital_status
    enum smoking: %i[Yes No Sometimes], _prefix: :smoking
    enum drinking: %i[Yes No Occasionally], _prefix: :drinking
    enum height_type: %i[cm inches foot], _prefix: :height_type
    enum weight_type: %i[kg pounds(lbs)], _prefix: :weight_type

    enum body_type: %i[Athletic Average Fat Slim], _prefix: :body_type
    enum mother_tougue: %i[
      Arabic Bengali Chinese English French German Gujarati Hindi Indonesian Italian
      Japanese Malayalam Marathi Nepali Portuguese Punjabi Russian Spanish Swahili
      Tamil Telugu Turkish Urdu
    ], _prefix: :mother_tougue
    enum religion: %i[Buddhist Christian Hindu Jain Muslim Sikh], _prefix: :religion
    enum zodiac: %i[Aquarius Aries Cancer Capricorn Gemini Leo Libra Pisces Sagittarius Scorpio Taurus Virgo],
         _prefix: :zodiac

    validates :languages, presence: true

    accepts_nested_attributes_for :educations, :achievements, :careers, allow_destroy: true

    INTERESTS_VALUES = [
      'Sports', 'Fitness', 'Cooking', 'Traveling', 'Politics', 'Adventures', 'Music',
      'Pets', 'Mountains', 'Beaches', 'Cooking', 'Nature', 'Photography', 'Dancing',
      'Painting', 'Pets', 'Music', 'Puzzles', 'Gardening', 'Reading Books', 'Handicrafts',
      'Movies', 'Night Outs', 'Stargazing', 'Internet', 'Surfing', 'Traveling',
      'Chit Chat', 'Sports', 'Adventures', 'Trekking', 'Hiking', 'Yoga', 'Workouts',
      'Baking', 'Binge-Watching', 'Calligraphy', 'Blogging', 'Writing', 'Drama',
      'Home Improving', 'Journaling', 'Knitting', 'Martial Arts', 'Miniature Art',
      'Poetry', 'Sewing', 'Sketching', 'Singing', 'Video Gaming', 'Wood Carving',
      'Astronomy', 'Bird Watching', 'Fishing', 'Swimming', 'Nature'
    ].freeze

    PERSONALITY_VALUES = [
      'Extrovert', 'Introvert', 'Creative', 'Angry', 'Cool', 'Emotional', 'Practical',
      'Rules Breaker', 'Stick To Rules', 'Optimistic', 'Pessimist', 'Hard Work',
      'Smart Work', 'Spendthrift', 'Miser', 'Good Listener', 'Talks a Lot', 'Childish',
      'Matured', 'Patient', 'Impatient', 'Competitive', 'Relaxed', 'Last-Minute Person',
      'Pre-Planner', 'Foodie', 'Book Bug', 'Shopaholic', 'Morning Person', 'Night Owl'
    ].freeze

    validates_intersection_of :personality, in: PERSONALITY_VALUES, message: 'invalid personality'
    validates_intersection_of :interests, in: INTERESTS_VALUES, message: 'invalid interests'
  end
end
# rubocop:enable Naming/VariableNumber, Lint/IneffectiveAccessModifier, Metrics/AbcSize, Naming/MemoizedInstanceVariableName, Metrics/MethodLength,  Lint/UselessAssignment, Metrics/ClassLength, Style/GlobalVars
