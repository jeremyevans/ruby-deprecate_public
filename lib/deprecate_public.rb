class Module
  module DeprecatePublic
    # Handle calls to methods where +deprecate_public+ has been called
    # for the method, printing the warning and then using +send+ to
    #invoke the method.
    def method_missing(meth, *args, &block)
      check_meth = "_deprecated_public_message_#{meth}"
      if respond_to?(meth, true) && respond_to?(check_meth, true) && (msg = send(check_meth))
        if RUBY_VERSION >= '2.5'
          Kernel.warn(msg, :uplevel => 1)
        else
          Kernel.warn("#{caller(1,1)[0].sub(/in `.*'\z/, '')} warning: #{msg}")
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
end
