# See spec/models/concerns/shared/ for functional tests on a fake Model, this only tests for include
shared_examples 'has_papertrail' do
  specify 'class includes Shared::HasPapertrail' do
    expect(described_class.ancestors.map(&:name).include?('Shared::HasPapertrail')).to be true
  end
end


