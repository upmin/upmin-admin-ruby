module Upmin
  module InstancesHelper

    def models_path
      return "#{root_path}models/"
    end

    def instance_path(instance)
      return "#{models_path}#{instance.class.name}/#{instance.id}"
    end

  end
end
