class Album < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search, :against => :title,
    using: { tsearch: {dictionary: "english" } },
    associated_against: { artist: :name, songs: :title },
    ignoring: :accents

  belongs_to :artist
  has_many :songs, dependent: :destroy

  validates_presence_of :title
  validates_uniqueness_of :title, case_insensitive: false

end
