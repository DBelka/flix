class Movie < ApplicationRecord

  before_save :set_slug

  has_many :reviews, -> { order(created_at: :desc) }, dependent: :destroy
  has_many :favourites, dependent: :destroy
  has_many :fans, through: :favourites, source: :user
  has_many :characterisations, dependent: :destroy
  has_many :genres, through: :characterisations

  validates :title, presence: true, uniqueness: true
  validates :released_on, :duration, presence: :true
  validates :description, length: { minimum: 25 }
  validates :total_gross, numericality: { greater_than_or_equal_to: 0 }
  validates :image_file_name, format: {
    with: /\w+\.(jpg|png)\z/i,
    message: "must be a JPG or PNG image"
  }

  RATINGS = %w(G PG PG-13 R NC-17)

  validates :rating, inclusion: { in: RATINGS }

  scope :released, -> { where("released_on < ?", Time.now).order("released_on DESC") }
  scope :upcoming, -> { where("released_on > ?", Time.now).order("released_on DESC") }
  scope :recent, ->(max=5) { released.limit(max) }
  scope :hits, -> { released.where("total_gross >= 300000000").order(total_gross: :desc) }
  scope :flops, -> { released.where("total_gross < 22500000").order(total_gross: :asc) }
  scope :grossed_less_than, ->(n) { released.where("total_gross < ?", n).order(total_gross: :asc) }
  scope :grossed_greater_than, ->(n) { released.where("total_gross > ?", n).order(total_gross: :asc) }

  def flop?
    (total_gross.blank? || total_gross < 226000000) && !self.is_cult?
  end

  def is_cult?
    reviews.count.to_i > 50.0 && reviews.average(:stars).to_f > 4.0
  end

  def average_stars
    reviews.average(:stars) || 0.0
  end

  def average_stars_as_percent
    (self.average_stars / 5.0) * 100
  end

  def to_param
    slug
  end

private

  def set_slug
    self.slug = title.parameterize
  end
end
