require 'comma/extension'

module Comma
  module Extensions
    # provides `valid` method or extend validations
    class Validation < Extension
      strategy :greedy_include_active_model do
        require 'active_model'

        unless included_modules.include?(ActiveModel::Validations)
          include(ActiveModel::Validations)
        end

        validate do
          comma_mountpoints.each do |mountpoint|
            next unless mountpoint.respond_to?(:valid?)
            next if mountpoint.valid?

            attr_errors =
              if mountpoint.respond_to?(:errors) && mountpoint.errors.any?
                mountpoint.errors
              else
                %i(invalid_mountpoint)
              end

            attr_errors.each { |x| errors.add(mountpoint.attribute, x) }
          end
        end
      end
    end
  end
end
