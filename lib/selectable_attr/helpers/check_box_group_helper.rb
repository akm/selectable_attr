require 'selectable_attr/helpers/abstract_selection_helper'
module SelectableAttr::Helpers
  module CheckBoxGroupHelper
    class Builder < SelectableAttr::Helpers::AbstractSelectionBuilder
      DefaultJsOptions = {
        :separator => ",",
        :apply_automatically => true, 
        :observe_checkboxes => false
      }
      
      def initialize(object, object_name, method, options, template)
        super(object, object_name, method, options, template)
        @entry_hash_array ||= enum_hash_array_from_object
        @param_name = "#{@base_name}_ids"
        @hidden_field_id = tag_id(@template.hidden_field(@object_name, @param_name))
        @check_box_class = "#{@hidden_field_id}_check_boxes"
        @check_box_options = add_class_name(@options.delete(:check_box), @check_box_class)
        @options = camelize_keys(DefaultJsOptions.merge(@options))
      end
      
      def each(&block)
        @entry_hash_array.each do |@entry_hash|
          @tag_value = @entry_hash[:id].to_s.gsub(/\s/, "_").gsub(/\W/, "").downcase
          @check_box_id = "#{@object_name}_#{@param_name}_#{@tag_value}"
          yield(self)
        end
      end
      
      def hidden_fields(options = nil)
        result = ''
        each do 
          result << hidden_field(options)
        end
        result
      end
      
      def hidden_field(options = nil)
        options = update_options({
            :id => @hidden_field_id, :type => 'hidden', :value => @tag_value,
            :name => "#{@object_name}[#{@param_name}][]"
          }, options)
        @template.content_tag("input", nil, options)
      end
      
      def script
        "<script>new HTMLInputElement.CheckboxText($(\"#{@hidden_field_id}\"), \"#{@check_box_class}\", #{@options.to_json});</script>"
      end
      
      def check_box(options = nil)
        options = update_options({
            :id => @check_box_id, :type => 'checkbox', :value => @tag_value,
            :name => "#{@object_name}[#{@param_name}][]"
          }, @check_box_options, options)
        options[:checked] = 'checked' if @entry_hash[:select]
        @template.content_tag("input", nil, options)
      end
      
      def label(text = nil, options = nil)
        @template.content_tag("label", text || @entry_hash[:name],
          update_options({:for => @check_box_id}, options))
      end
    end

    module Base
      def check_box_group(object_name, method, options = nil, &block)
        object = (options || {})[:object] || instance_variable_get("@#{object_name}")
        builder = Builder.new(object, object_name, method, options, self)
        if block_given?
          yield(builder)
          return nil
        else
          result = ''
          builder.each do
            result << builder.check_box
            result << '&nbsp;'
            result << builder.label
            result << '&nbsp;'
          end
          return result
        end
      end
    end
    
    module FormBuilder
      def check_box_group(method, options = nil, &block)
        @template.check_box_group(@object_name, method, 
          (options || {}).merge(:object => @object), &block)
      end
    end
  end
end
