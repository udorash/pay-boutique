module PayBoutique
  class Signature
    def self.sign_params(array)
      array = [array].flatten
      Digest::SHA512.hexdigest(
          PayBoutique.configuration.user_id.upcase +
              Digest::SHA512.hexdigest(PayBoutique.configuration.password).upcase +
              array.join.upcase).upcase
    end
  end
end
