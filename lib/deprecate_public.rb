class Module
  module DeprecatePublic
    # Handle calls to methods where +deprecate_public+ has been called
    # for the method, printing the warning and then using +send+ to
    # invoke the method.
    def method_missing(meth, *args, &block)
      check_meth = "_deprecated_public_message_#{meth}"
      if respond_to?(meth, true) && respond_to?(check_meth, true) && (msg = send(check_meth))
        if RUBY_VERSION >= '2.5'
          Kernel.warn(msg, :uplevel => 1)
        # :nocov:
        elsif RUBY_VERSION >= '2.0'
          Kernel.warn("#{caller(1,1)[0].sub(/in `.*'\z/, '')} warning: #{msg}")
        else
          Kernel.warn("#{caller(1)[0].sub(/in `.*'\z/, '')} warning: #{msg}")
        # :nocov:
        end

        send(meth, *args, &block)
      else
        super
      end
    end
  end

  # Allow but deprecate public method calls to +meth+, if +meth+ is
  # protected or private.  +meth+ can be an array of method name strings
  # or symbols to handle multiple methods at once.  If +msg+ is specified,
  # it can be used to customize the warning printed.
  def deprecate_public(meth, msg=nil)
    include DeprecatePublic

    Array(meth).each do |m|
      message = (msg || "calling #{name}##{m} using deprecated public interface").dup.freeze
      message_meth = :"_deprecated_public_message_#{m}"
      define_method(message_meth){message}
      private message_meth
    end

    nil
  end

  # :nocov:
  if RUBY_VERSION >= '2.6'
  # :nocov:
    module DeprecatePublicConstant
      # Handle access to constants where +deprecate_public_constant+ has been called
      # for the constant, printing the warning and then using +const_get+ to
      # access the constant.
      def const_missing(const)
        check_meth = "_deprecated_public_constant_message_#{const}"
        if const_defined?(const, true) && respond_to?(check_meth, true) && (msg = send(check_meth))
          Kernel.warn(msg, :uplevel => 1)
          const_get(const, true)
        else
          super
        end
      end
    end

    # Allow but deprecate public constant access to +const+, if +const+ is
    # a private constant.  +const+ can be an array of method name strings
    # or symbols to handle multiple methods at once.  If +msg+ is specified,
    # it can be used to customize the warning printed.
    def deprecate_public_constant(const, msg=nil)
      extend DeprecatePublicConstant

      Array(const).each do |c|
        message = (msg || "accessing #{name}::#{c} using deprecated public interface").dup.freeze
        message_meth = :"_deprecated_public_constant_message_#{c}"
        define_singleton_method(message_meth){message}
        singleton_class.send(:private, message_meth)
      end

      nil
    end
  end
end
