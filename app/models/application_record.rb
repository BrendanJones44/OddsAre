# Top level model for Rails
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
