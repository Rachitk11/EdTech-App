module BxBlockContentManagement
  module Interface
    def need_to_implement(*method_names)
      method_names.each do |method_name|
        define_method(method_name) { |*args|
          raise "Not implemented #{method_name}, please add method to your module."
        }
      end
    end
  end
end
