require 'spec_helper'
describe TaxonName do

  let(:taxon_name) { TaxonName.new }
  before(:all) do
    TaxonName.delete_all
    TaxonNameRelationship.delete_all
    @subspecies = FactoryGirl.create(:iczn_subspecies)
    @species = @subspecies.ancestor_at_rank('species')
    @genus = @subspecies.ancestor_at_rank('genus')
    @family = @subspecies.ancestor_at_rank('family')
    @root = @subspecies.root
  end

  after(:all) do
    TestDbCleanup.cleanup_taxon_name_and_related
  end

  context 'double checking FactoryGirl' do
    specify 'is building all related names for respective models' do
      expect(@subspecies.ancestors.length).to be >= 10
      (@subspecies.ancestors + [@subspecies]).each do |i|
        expect(i.valid?).to be_true
      end
    end
    specify 'ICN' do
      variety = FactoryGirl.create(:icn_variety)
      expect(variety.ancestors.length).to be >= 17
      (variety.ancestors + [variety]).each do |i|
        expect(i.valid?).to be_true
      end
      expect(variety.root.id).to eq(@species.root.id)
      #variety.save

      expect(variety.cached_higher_classification).to eq('Plantae:Aphyta:Aphytina:Aopsida:Aidae:Aales:Aineae:Aaceae:Aoideae:Aeae:Ainae')
      expect(variety.cached_author_year).to eq('McAtee (1900)')
      expect(variety.cached_name).to eq('Aus (Aus sect. Aus ser. Aus) aaa bbb var. ccc')
    end
  end

  context 'associations' do 
    specify 'responses to source' do
      expect(taxon_name).to respond_to(:source)
    end

    context 'taxon_name_relationships' do

      before(:all) do
        @type_of_genus = FactoryGirl.create(:iczn_genus, name: 'Bus', parent: @family)
        @original_genus = FactoryGirl.create(:iczn_genus, name: 'Cus', parent: @family)
        @taxon_name = FactoryGirl.create(:iczn_species, name: 'aus', parent: @type_of_genus)
        @relationship1 = FactoryGirl.create(:type_species_relationship, subject_taxon_name: @taxon_name, object_taxon_name: @type_of_genus )
        @relationship2 = FactoryGirl.create(:taxon_name_relationship, subject_taxon_name: @original_genus, object_taxon_name: @taxon_name, type: 'TaxonNameRelationship::OriginalCombination::OriginalGenus')
      end

      specify 'respond to taxon_name_relationships' do
        expect(taxon_name).to respond_to(:taxon_name_relationships)
      end 

      context 'methods related to taxon_name_relationship associations (returning Array)' do
        # TaxonNameRelationships in which the taxon name is the subject
        specify 'respond to taxon_name_relationships' do
          expect(@taxon_name).to respond_to (:taxon_name_relationships)
          expect(@taxon_name.taxon_name_relationships.map{|i| i.type_name}).to eq([@relationship1.type_name])
        end

        # TaxonNameRelationships in which the taxon name is the subject OR object
        specify 'respond to all_taxon_name_relationships' do
          expect(@taxon_name).to respond_to (:all_taxon_name_relationships)
          expect(@taxon_name.all_taxon_name_relationships.map{|i| i.type_name}).to eq([@relationship1.type_name, @relationship2.type_name])
        end

        # TaxonNames related by all_taxon_name_relationships
        specify 'respond to related_taxon_names' do
          expect(@taxon_name.related_taxon_names.sort).to eq([@type_of_genus, @original_genus].sort)
        end

        specify 'respond to unavailable_or_invalid' do
          relationship = FactoryGirl.build(:taxon_name_relationship, subject_taxon_name: @original_genus, object_taxon_name: @type_of_genus, type: 'TaxonNameRelationship::Iczn::Invalidating::Synonym')
          expect(relationship.save).to be_true
          expect(@type_of_genus.unavailable_or_invalid?).to be_false
          expect(@original_genus.unavailable_or_invalid?).to be_true
        end
      end
    end
  end

  context 'methods' do
    context 'verbatim_author' do 
      specify 'parens are allowed' do
        taxon_name.verbatim_author = '(Smith)' 
        taxon_name.valid?
        expect(taxon_name.errors.include?(:verbatim_author)).to be_false
      end
    end

    context 'rank_class' do 
      specify 'returns the passed value when not yet validated and not a NomenclaturalRank' do
        taxon_name.rank_class = 'foo'
        expect(taxon_name.rank_class).to eq('foo') 
      end
      specify 'returns a NomenclaturalRank when available' do
        taxon_name.rank_class = Ranks.lookup(:iczn, 'order')
        expect(taxon_name.rank_class).to eq(NomenclaturalRank::Iczn::HigherClassificationGroup::Order)
        taxon_name.rank_class = Ranks.lookup(:icn, 'family')
        expect(taxon_name.rank_class).to eq(NomenclaturalRank::Icn::FamilyGroup::Family)
      end
    end

    context 'rank' do
      specify 'returns nil when not a NomenclaturalRank (i.e. invalidly_published)' do
        taxon_name.rank_class = 'foo'
        expect(taxon_name.rank).to be_nil
      end
      specify 'returns vernacular when rank_class is a NomenclaturalRank (i.e. validly_published)' do
        taxon_name.rank_class = Ranks.lookup(:iczn, 'order')
        expect(taxon_name.rank).to eq('order')
        taxon_name.rank_class = Ranks.lookup(:icn, 'family')
        expect(taxon_name.rank).to eq('family')
      end
    end

    context 'nomenclature_date' do
      before(:all) do
        @f1 = FactoryGirl.create(:relationship_family, year_of_publication: 1900)
        @f2 = FactoryGirl.create(:relationship_family, year_of_publication: 1950)
      end
      specify 'simple case' do
        expect(@f2.nomenclature_date.year).to eq(1950)
      end
      specify 'family replacement before 1961' do
        r = FactoryGirl.create(:taxon_name_relationship, subject_taxon_name: @f2, object_taxon_name: @f1, type: 'TaxonNameRelationship::Iczn::PotentiallyValidating::FamilyBefore1961')
        expect(@f2.nomenclature_date.year).to eq(1900)
      end
    end
  end

  context 'hierarchy' do
    context 'rank related' do
      context 'ancestor_at_rank' do
        specify 'returns an ancestor at given rank' do
          expect(@genus.ancestor_at_rank('family').name).to eq('Cicadellidae')
        end
        specify "returns nil when given rank and name's rank are the same" do
          expect(@genus.ancestor_at_rank('genus')).to be_nil
        end
        specify "returns nil when given rank is lower than name's rank" do
          expect(@genus.ancestor_at_rank('species')).to be_nil
        end
        specify 'returns nil when given rank is not present in the parent chain' do
          expect(@genus.ancestor_at_rank('epifamily')).to be_nil
        end
      end
    end

    context 'class methods from awesome_nested_set' do
      specify 'permit one root per project'
      specify 'permit multiple roots across the database' do
        root2 = FactoryGirl.build(:root_taxon_name)
        expect(root2.parent).to be_nil
        expect(root2.valid?).to be_true
      end

      # run through the awesome_nested_set methods: https://github.com/collectiveidea/awesome_nested_set/wiki/_pages
      context 'handle a simple hierarchy with awesome_nested_set' do
        before(:all) do
          @family1 = FactoryGirl.create(:iczn_family, parent: @root)
          @genus1 = FactoryGirl.create(:iczn_genus, parent: @family1)
          @genus2 = FactoryGirl.create(:iczn_genus, parent: @family1)
          @species1 = FactoryGirl.create(:iczn_species, parent: @genus1)
          @species2 = FactoryGirl.create(:iczn_species, parent: @genus2)
          @root.reload
        end

        specify 'root' do
          expect(@species1.root).to eq(@root)
        end
        specify 'ancestors' do
          expect(@root.ancestors.size).to eq(0)
          expect(@family1.ancestors.size).to eq(1)
          expect(@family1.ancestors).to eq([@root])
          expect(@species1.ancestors.size).to eq(3)
        end
        specify 'parent' do
          expect(@root.parent).to eq(nil)
          expect(@family1.parent).to eq(@root)
        end
        specify 'leaves' do
          expect(@root.leaves & [@species1, @species2]).to eq([@species1, @species2])
        end
        specify 'move_to_child_of' do
          @species2.move_to_child_of(@genus1)
          expect(@genus2.children).to eq([])
          expect(@genus1.children).to eq([@species1,@species2])
        end
      end
    end
  end

  context 'validation' do
    before do
      taxon_name.valid?
    end

    context 'required fields' do
      specify 'rank' do
        expect(taxon_name.errors.include?(:rank_class)).to be_true
      end
      specify 'type' do
        expect(taxon_name.type).to eq('Protonym')
      end
    end

    context 'proper taxon rank' do
      specify 'parent rank is higher' do
        taxon_name.update(rank_class: Ranks.lookup(:iczn, 'Genus'), name: 'Aus')
        taxon_name.parent = @species
        taxon_name.valid?
        expect(taxon_name.errors.include?(:parent_id)).to be_true
      end
      specify 'child rank is lower' do
        phylum = FactoryGirl.create(:iczn_phylum)
        kingdom = phylum.ancestor_at_rank('kingdom')
        kingdom.rank_class = Ranks.lookup(:iczn, 'subphylum')
        kingdom.valid?
        expect(kingdom.errors.include?(:rank_class)).to be_true
      end
      specify 'a new taxon rank in the same group' do
        t = FactoryGirl.create(:iczn_kingdom)
        t.rank_class = Ranks.lookup(:iczn, 'genus')
        t.valid?
        expect(t.errors.include?(:rank_class)).to be_true
      end
    end

    context 'source' do
      specify 'when provided, is type Source::Bibtex' do
        h = FactoryGirl.build(:human_source)
        taxon_name.source = h
        taxon_name.valid?
        expect(taxon_name.errors.include?(:source_id)).to be_true
        b = FactoryGirl.build(:source_bibtex)
        taxon_name.source = b
        taxon_name.valid?
        expect(taxon_name.errors.include?(:source_id)).to be_false
      end
    end

    context 'rank_class' do
      specify 'is validly_published when a NomenclaturalRank subclass' do
        taxon_name.rank_class = Ranks.lookup(:iczn, 'order')
        taxon_name.name = 'Aaa'
        taxon_name.valid?
        expect(taxon_name.errors.include?(:rank_class)).to be_false
      end
      specify 'is invalidly_published when not a NomenclaturalRank subclass' do
        taxon_name.rank_class = 'foo'
        taxon_name.valid?
        expect(taxon_name.errors.include?(:rank_class)).to be_true
      end
    end

    context 'name' do
      context 'validate cashed values' do
        specify 'ICZN subspecies' do
          @subspecies.valid?
          expect(@subspecies.cached_higher_classification).to eq('Animalia:Arthropoda:Insecta:Hemiptera:Cicadellidae:Typhlocybinae:Erythroneurini:Erythroneurina')
          expect(@subspecies.cached_author_year).to eq('McAtee, 1900')
          expect(@subspecies.cached_name).to eq('Erythroneura (Erythroneura) vitis ssp')
        end
        specify 'ICZN family' do
          expect(@family.valid?).to be_true
          expect(@family.cached_higher_classification).to eq('Animalia:Arthropoda:Insecta:Hemiptera:Cicadellidae')
          expect(@family.cached_author_year).to eq('Say, 1800')
          expect(@family.cached_name.nil?).to be_true
        end
        specify 'nil author and year - cashed value should be empty' do
          t = @subspecies.ancestor_at_rank('kingdom')
          t.valid?
          expect(t.cached_author_year).to eq('')
        end
        specify 'moving nominotypical taxon' do
          sp = FactoryGirl.create(:iczn_species, name: 'aaa', parent: @genus)
          subsp = FactoryGirl.create(:iczn_subspecies, name: 'aaa', parent: sp)
          subsp.parent = @species
          subsp.valid?
          expect(subsp.errors.include?(:parent_id)).to be_true
        end
      end

      context 'when rank ICZN family' do
        specify "is validly_published when ending in '-idae'" do
          @family.valid?
          expect(@family.errors.include?(:name)).to be_false
        end
        specify "is invalidly_published when not ending in '-idae'" do
          taxon_name.name = 'Aus'
          taxon_name.rank_class = Ranks.lookup(:iczn, 'family')
          taxon_name.valid?
          expect(taxon_name.errors.include?(:name)).to be_true
        end
        specify 'is invalidly_published when not capitalized' do
          taxon_name.name = 'fooidae'
          taxon_name.rank_class = Ranks.lookup(:iczn, 'family')
          taxon_name.valid?
          expect(taxon_name.errors.include?(:name)).to be_true
        end
      end

      context 'when rank ICN family' do
        specify "is validly_published when ending in '-aceae'" do
          taxon_name.name = 'Aaceae'
          taxon_name.rank_class = Ranks.lookup(:icn, 'family')
          taxon_name.valid?
          expect(taxon_name.errors.include?(:name)).to be_false
        end
        specify "is invalidly_published when not ending in '-aceae'" do
          taxon_name.name = 'Aus'
          taxon_name.rank_class = Ranks.lookup(:icn, 'family')
          taxon_name.valid?
          expect(taxon_name.errors.include?(:name)).to be_true
        end
      end
    end

    context 'relationships' do
      specify 'invalid parent' do
        g = FactoryGirl.create(:iczn_genus, parent: @family)
        s = FactoryGirl.create(:iczn_species, parent: g)
        r1 = FactoryGirl.create(:taxon_name_relationship, subject_taxon_name: g, object_taxon_name: @genus, type: 'TaxonNameRelationship::Iczn::Invalidating::Synonym')
        c1 = FactoryGirl.create(:taxon_name_classification, taxon_name: g, type: 'TaxonNameClassification::Iczn::Unavailable::NomenNudum')
        s.soft_validate(:parent_is_valid_name)
        g.soft_validate(:parent_is_valid_name)
        expect(s.soft_validations.messages_on(:parent_id).count).to eq(1)
        expect(g.soft_validations.messages_on(:base).count).to eq(1)
        s.fix_soft_validations
        s.soft_validate(:parent_is_valid_name)
        expect(s.soft_validations.messages_on(:parent_id).empty?).to be_true
      end
    end
  end

  context 'concerns' do
    it_behaves_like 'identifiable'
    it_behaves_like 'citable'
  end
end
