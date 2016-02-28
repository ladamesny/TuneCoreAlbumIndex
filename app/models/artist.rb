class Artist < ActiveRecord::Base
  include PgSearch
  multisearchable :against => [:name]
  pg_search_scope :search_by_name, :against => :name

  has_many :albums, dependent: :destroy

  validates_presence_of :name
  validates_uniqueness_of :name, case_insensitive: false

end
