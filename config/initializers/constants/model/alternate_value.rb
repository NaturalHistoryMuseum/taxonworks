# Be sure to restart your server when you modify this file.

Rails.application.config.after_initialize do 
  ALTERNATE_VALUE_CLASSES = AlternateValue.descendants.freeze
  ALTERNATE_VALUE_CLASS_NAMES = ALTERNATE_VALUE_CLASSES.collect{|d| d.to_s}.freeze
end
