module Proof
  module Runner
    module Matchers
      FAIL = /^(-> Fail:)(.*)/
      PASS = /^(Pass:)(.*)/
      ERROR = /^(Error:)(.*)/
      REGULAR = /^(?!(Error|-> Fail|Pass))(.*)/
    end
  end
end
