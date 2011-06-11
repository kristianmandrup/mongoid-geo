module InflectionsHelper
  def configure!
    let(:base) do
      Mongoid::Criteria.new(Address)
    end
  end
end