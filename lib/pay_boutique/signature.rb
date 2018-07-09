module PayBoutique
  class Signature
    class << self
      def create(*args)
        Digest::SHA512
          .hexdigest((user_id + Digest::SHA512.hexdigest(password) + args.join).upcase)
          .upcase
      end

      private

      def user_id
        PayBoutique.configuration.user_id
      end

      def password
        PayBoutique.configuration.password
      end
    end
  end
end
