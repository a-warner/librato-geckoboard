require './app'

# For some reason Puma::DSL uses app not run
if !respond_to?(:run) && respond_to?(:app)
  alias run app
end

run LibratoGeckoboard
