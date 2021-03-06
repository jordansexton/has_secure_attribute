require 'ruby_utils/abstract_class'
require 'active_support/core_ext/object/blank'

module HasSecureAttribute
  class AbstractCipher
    extend AbstractClass

    def digest (secret)
      raise NotImplementedError,
            "#{__method__} must be overridden by a subclass."
    end

    def authenticate (secret_digest, secret)
      raise NotImplementedError,
            "#{__method__} must be overridden by a subclass."
    end

    private

    # Constant-time comparison algorithm to prevent timing attacks
    # Derived from ActiveSupport::MessageVerifier#secure_compare
    def compare (a, b)
      return false if a.blank? || b.blank? || a.bytesize != b.bytesize

      l   = a.unpack("C#{a.bytesize}")
      res = 0
      b.each_byte { |byte| res |= byte ^ l.shift }
      res == 0
    end
  end
end
