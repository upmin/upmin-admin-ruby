module Upmin
  class InvalidAction < ArgumentError
    def initialize(action)
      super("Invalid action: #{action}")
    end
  end

  class MissingArgument < ArgumentError
    def initialize(arg)
      super("Missing argument: #{arg}")
    end
  end

  class ArgumentError < ArgumentError
    def initialize(arg)
      super("Invalid argument: #{arg}")
    end
  end

  class MissingPartial < ::StandardError
    def initialize(data)
      super("Could not find a matching partial with the following data: #{data.as_json}")
    end
  end

  class UnsupportedObjectMapper < ::StandardError
    def initialize
      super("The ORM or ODM you are using is not supported. Please create an issue on github if one doesn't exist - https://github.com/upmin/upmin-admin-ruby/issues")
    end
  end

  class UninferrableAdminError < NameError
    def initialize(klass)
      super("Could not infer an Admin class for #{klass}.")
    end
  end

  class UninferrableSourceError < NameError
    def initialize(klass)
      super("Could not infer a source for #{klass}.")
    end
  end
end
