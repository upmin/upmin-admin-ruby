# module Upmin
#   module Graph
#   end
# end

# class Upmin::Graph::Node
#   def initialize(model, depth = 0)
#     @model = model
#     @depth = depth
#   end

#   def model
#     return @model
#   end

#   def depth
#     return @depth
#   end

#   def attributes
#     return @attributes ||= create_attributes
#   end

#   def children
#     if @depth >= 2
#       return [] # nothing beyond a depth of 2
#     else
#       return @children ||= create_children
#     end
#   end

#   private
#     def create_attributes
#       attributes = []
#       model.upmin_attributes.each do |u_attr|
#         attributes << {
#           name: u_attr.to_sym,
#           value: model.upmin_get(u_attr),
#           editable: depth == 0 && model.upmin_attr_editable?(u_attr),
#           type: model.upmin_attr_type(u_attr)
#         }
#       end
#       return attributes
#     end

#     def create_children
#       @singletons = []
#       @collections = []
#       model.upmin_associations.each do |association|
#         puts "Association=#{association}"
#         v = model.upmin_get_assoc(association)
#         puts "Value for assoc is: #{v} #{v.inspect}"
#         options = {
#           depth: depth + 1,
#           editable: false
#         }

#         if v.nil?
#           @singletons << DataNode.new(nil, depth: depth + 1)
#         elsif true

#         else

#         end

#         hash = {
#           name: association.to_sym,
#         }
#         if v.nil?
#           # TODO(jon): Make this work better
#           @singletons << hash.merge({
#             value: nil,
#             editable: false,
#             type: :nil
#           })
#         elsif v.is_a?(ActiveRecord::Base)
#           @singletons << hash.merge({
#             value: Node.new(v, depth + 1),
#             editable: false,
#             type: v.class.to_s.underscore.to_sym
#           })
#         else # Assume it is a collection or nil
#           type = :nil
#           type = v.first.class.to_s.underscore if v.any?
#           type = "#{type}_collection".to_sym

#           @collections << hash.merge({
#             value: "",
#             editable: false,
#             type: type
#           })
#         end
#       end

#       return @singletons + @collections
#     end

# end
