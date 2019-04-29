module FactoryBot
  # @api private
  class Trait
    attr_reader :name, :definition

    def initialize(name, &block) 
      @name = name.to_s
      @block = block
      @definition = Definition.new(@name)
      proxy = FactoryBot::DefinitionProxy.new(@definition)

      if block_given?
        ensure_trait_not_self_referencing?(proxy)
        proxy.instance_eval(&@block)
       end    
    end

    delegate :add_callback, :declare_attribute, :to_create, :define_trait, :constructor,
             :callbacks, :attributes, to: :@definition

    def names
      [@name]
    end

    def ==(other)
      name == other.name &&
        block == other.block
    end

    protected

    def ensure_trait_not_self_referencing?(trait)
      puts trait
      if trait.name == @name
        message = "Self-referencing trait '#{@name}'"
        raise TraitDefinitionError, message
      end
    end 

    attr_reader :block
  end
end
