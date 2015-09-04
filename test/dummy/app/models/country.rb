class Country < ActiveRecord::Base

  validates :name, presence: true

  def permited_attributes
    [:name, :code, :active]
  end

end
