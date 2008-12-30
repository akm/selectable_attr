module SelectableAttr

  class Enum
    include Enumerable
    include SelectableAttr::DbLoadable
    
    def initialize(&block)
      @entries = []
      instance_eval(&block) if block_given?
    end
    
    def entries
      @entries
    end
    
    def each(&block)
      entries.each(&block)
    end
    
    def define(id, key, name, options = nil, &block)
      entry = Entry.new(self, id, key, name, options, &block)
      entry.instance_variable_set(:@defined_in_code, true)
      @entries << entry
    end
    alias_method :entry, :define
    
    def i18n_scope(*path)
      @i18n_scope = path unless path.empty?
      @i18n_scope
    end
    
    def match_entry(entry, value, *attrs)
      attrs.any?{|attr| entry[attr].to_s == value.to_s}
    end

    def entry_by(value, *attrs)
      entries.detect{|entry| match_entry(entry, value, *attrs)} || Entry::NULL
    end
    
    def entry_by_id(id)
      entry_by(id, :id)
    end
    
    def entry_by_key(key)
      entry_by(key, :key)
    end
    
    def entry_by_id_or_key(id_or_key)
      entry_by(id_or_key, :id, :key)
    end
    
    def entry_by_hash(attrs)
      entries.detect{|entry| attrs.all?{|(attr, value)| entry[attr].to_s == value.to_s }} || Entry::NULL
    end
    
    def [](arg)
      arg.is_a?(Hash) ? entry_by_hash(arg) : entry_by_id_or_key(arg)
    end
    
    def values(*args)
      args = args.empty? ? [:name, :id] : args
      result = entries.collect{|entry| args.collect{|arg| entry.send(arg) }}
      (args.length == 1) ? result.flatten : result
    end
    
    def map_attrs(attrs, *ids_or_keys)
      if attrs.is_a?(Array)
        ids_or_keys.empty? ? 
          entries.map{|entry| attrs.map{|attr|entry.send(attr)}} : 
          ids_or_keys.map do |id_or_key|
            entry = entry_by_id_or_key(id_or_key)
            attrs.map{|attr|entry.send(attr)}
          end
      else
        attr = attrs
        ids_or_keys.empty? ? 
          entries.map(&attr.to_sym) : 
          ids_or_keys.map{|id_or_key|entry_by_id_or_key(id_or_key).send(attr)}
      end
    end
    
    def ids(*ids_or_keys); map_attrs(:id, *ids_or_keys); end
    def keys(*ids_or_keys); map_attrs(:key, *ids_or_keys); end
    def names(*ids_or_keys); map_attrs(:name, *ids_or_keys); end
    def options(*ids_or_keys); map_attrs([:name, :id], *ids_or_keys); end

    def key_by_id(id); entry_by_id(id).key; end
    def id_by_key(key); entry_by_key(key).id; end
    def name_by_id(id); entry_by_id(id).name; end
    def name_by_key(key); entry_by_key(key).name; end
    
    def find(options = nil, &block)
      entries.detect{|entry| 
          block_given? ? yield(entry) : entry.match?(options) 
        } || Entry::NULL
    end
    
    def to_hash_array
      entries.map do |entry|
        result = entry.to_hash
        yield(result) if defined? yield
        result
      end
    end
    
    def length
      entries.length
    end
    alias_method :size, :length

    class Entry
      BASE_ATTRS = [:id, :key, :name]
      attr_reader :id, :key
      attr_reader :defined_in_code
      def initialize(enum, id, key, name, options = nil, &block)
        @enum = enum
        @id = id
        @key = key
        @name = name
        @options = options
        self.instance_eval(&block) if block
      end
      
      if defined?(I18n)
        def name
          I18n.locale.nil? ? @name :
            @enum.i18n_scope.blank? ? @name :
            I18n.translate(key, :scope => @enum.i18n_scope, :default => @name)
        end
      else
        attr_reader :name
      end
      
      def [](option_key)
        BASE_ATTRS.include?(option_key) ? send(option_key) :
        @options ? @options[option_key] : nil
      end
      
      def match?(options)
        @options === options
      end
      
      def null?
        false
      end
      
      def null_object?
        self.null?
      end
      
      def to_hash
        (@options || {}).merge(:id => @id, :key => @key, :name => @name)
      end
      
      NULL = new(nil, nil, nil, nil) do
        def null?; true; end
        def name; nil; end
      end
    end
    
  end

end
