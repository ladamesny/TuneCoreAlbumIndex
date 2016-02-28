class Song < ActiveRecord::Base
  include PgSearch
  multisearchable :against => [:title]
  pg_search_scope :search_by_title, :against => :title

  belongs_to :album

  validates_presence_of :title

end
