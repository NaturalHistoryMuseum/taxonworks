require 'rails_helper'

describe Source, type: :model, group: :sources do

  let(:source) { Source::Bibtex.new(
    title: 'Bears in the woods',
    bibtex_type: 'article',
    year: 1776,
    month: 7,
    day: 4) }
  
  let(:person1) { Person.create!(last_name: 'Smith') }
  let(:person2) { Person.create!(last_name: 'Jones') }
  let(:person3) { Person.create!(last_name: 'Hammerstein') }

  context 'after save' do
    let!(:role1) { Role.create!(person: person1, type: 'SourceAuthor', role_object: source) }
    let!(:role2) { Role.create!(person: person2, type: 'SourceAuthor', role_object: source) }
    let!(:role3) { Role.create!(person: person3, type: 'SourceAuthor', role_object: source) }

    specify '#cached_author_string' do
      expect(source.cached_author_string).to eq('Smith, Jones & Hammerstein')
    end

    specify '#cached_nomenclature_date' do
      expect(source.cached_nomenclature_date.to_s).to eq('1776-07-04')
    end

    specify 'after role destroyed' do
      person1.roles.reload.each(&:destroy)
      expect(source.reload.cached_author_string).to eq('Jones & Hammerstein')
    end

    specify 'notice this pattern does NOT hit callbacks' do
      person1.roles.destroy
      expect(source.reload.cached_author_string).to eq('Smith, Jones & Hammerstein')
    end

    specify 'after person updated' do
      person1.update(last_name: 'Frank')
      expect(source.reload.cached_author_string).to eq('Frank, Jones & Hammerstein')
    end

  end
end
