require 'rails_helper'

# config/lib/application_record/nillify_blanks.rb
describe 'NilifyBlanks', group: [:model] do


  # Use OTU as a proxy
  #
  specify '#attributes_to_not_trim correctly assigns 1' do
    expect(Otu.ignore_whitespace_on(:name)).to be_truthy
  end

  specify '#attributes_to_not_trim correctly assigns 1' do
    Otu.ignore_whitespace_on(:name)
    expect(Otu.new.trimmable?('name')).to be_falsey
  end

  context 'cleanup' do
    let(:o) { Otu.new }
    let(:mess) { ' this is (not) a big         gap  ' }
    before { Otu.send(:reset_trimmable) }

    specify 'blank? attributes are nillified on validation' do
      o.name = ''
      o.valid?
      expect(o.name).to eq(nil) 
    end

    specify 'wrapped, and duplicated whitespaces is squished and trimmed' do
      o.name = mess
      o.valid?
      expect(o.name).to eq('this is (not) a big gap') 
    end

    context 'when ignored' do
      before do 
        Otu.ignore_whitespace_on(:name) 
        o.name = mess
      end

      specify 'is ignored?' do
        expect(o.trimmable?('name')).to be_falsey
      end

      specify 'ignored!' do
        o.valid?
        expect(o.name).to eq(mess)
      end
    end

  end
end

 
