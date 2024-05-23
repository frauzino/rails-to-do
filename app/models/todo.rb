class Todo < ApplicationRecord
  validates :content, presence: true
  before_save :set_title_from_content

  private

  def set_title_from_content
    return unless title.blank? && content.present?

    self.title = content.split.first(3).join(' ')
  end
end
