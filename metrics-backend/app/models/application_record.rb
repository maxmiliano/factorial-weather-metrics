# frozen_string_literal: true

# Base class for all models. All models should inherit from this class and shared functionality should be defined here.
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
