module Upmin
  class ArgumentError < ArgumentError
    def initialize(arg)
      super("Invalid argument: #{arg}")
    end
  end

  class MissingPartial < ActionView::MissingTemplate
    def initialize(data)
      super("Could not find a matching partial with the following data: #{data}")
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
