require 'set'

module AccordiveRails
  class Instance

    attr_accessor :rails_instance

    def initialize(rails_instance)
      self.rails_instance = rails_instance
    end

    def model_methods
      @model_methods ||= [
        :support_attributes,
        :support_attribute?,
        :support_methods,
        :support_method?,
        :support_associations,
        :support_association,
        :support_association?
      ]
    end

    # Note - this returns whatever the method it calls returns,
    # unless it wraps objects in the Instance class
    def method_missing(m, *args, &block)
      if model_methods.include?(m.to_sym)
        return model.send(m, *args, &block)
      end

      if support_attribute?(m)
        return rails_instance.send(m, *args, &block)
      elsif support_method?(m)
        return rails_instance.send(m, *args, &block)
      elsif support_association?(m)
        return rails_instance.send(m, *args, &block)
      else
        super
      end
    end

    def rails_class
      rails_instance.class
    end

    def model
      Model.for(rails_class)
    end

    # Key, eql, and hash are all there to make life easier with hashes, sets, etc.
    def key
      return "#{rails_class},#{id}"
    end

    def eql?(other)
      return key == other.key
    end

    def hash
      key.hash
    end


    # TODO(jon): Clean this up some. Prob could be a few smaller methods that are simpler to test.
    def as_json(options = {})
      hashes = {}
      edges = {}
      edges[key] = Set.new

      queue = Queue.new
      queue << self
      found = 0

      until queue.empty? && found < 50
        found += 1 # for sanity - dont want to go hogwild
        cur = queue.pop()
        hashes[cur.key] = cur.to_hash

        cur.support_associations.each do |association|
          # Get all associated instances

          instances = []
          if association.singular?
            instance = cur.send(association.method)
            instance = instance.accordify if instance
            instances << instance if instance
          else
            instances = cur.send(association.method).limit(5).accordify
          end

          instances.select! { |i| !edges[i.key] }
          instances.each { |i| queue << i }
          instances.each { |i| edges[i.key] = Set.new }
          edges[cur.key] << [association.method, instances.map(&:key)]
        end
      end

      # We should have all base jbuilders, and we should know all the correct edges to use.
      hashes.each do |cur_key, hash|
        hash[:associations] ||= {}
        edges[cur_key].each do |method, instance_keys|
          hash[:associations][method] = instance_keys.map { |k| hashes[k] }
        end
      end

      return hashes[key]
    end

    def to_hash
      hash = {}
      hash[:object] = rails_class.to_s
      support_attributes.each do |attribute|
        hash[attribute] = send(attribute)
      end
      hash[:actions] = support_methods
      return hash
    end

    def to_json
      return as_json.to_json
    end
  end
end
