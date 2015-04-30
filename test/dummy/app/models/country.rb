class Country < ActiveRecord::Base

  def permited_attributes
    [:name, :code, :active]
  end

end
