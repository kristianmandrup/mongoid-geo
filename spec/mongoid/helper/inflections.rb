module InflectionsHelper
  let(:base) do
    Mongoid::Criteria.new(Address)
  end
end