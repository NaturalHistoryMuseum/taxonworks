class Api::V1::RpcController < ApiController

	def rpc
		Current.user_id = request.headers.env['HTTP_X_USER']
		Current.project_id = request.headers.env['HTTP_X_PROJECT']
		request.headers.env['HTTP_X_PROJECT']
		#render json: {:result=>params['rpc']}, status: :ok
		value = send(params['rpc']['method'], *params['rpc']['params'])
    render json: {:result=>value }, status: :ok
	end

	def method(value)
		a = Source::Bibtex.new_from_bibtex(value)
		if a.valid?
			a.save
		end
		'Created'
	end

	def test(*params)
		['Received params', params]
	end

	def createPerson(args)
		Person.create!(
			last_name: args['lastName'],
			first_name: args['firstName'],
			suffix: args['suffix']
		)
	end

	def createSource(props)
		roles = props['contributors'].map do |cid|
			SourceAuthor.new(person_id: cid, position: 'Author')
		end

		Source::Bibtex.create!(
			bibtex_type: props['type'],
			year: props['year'],
			journal: props['journal'],
			title: props['title'],
			language: props['language'],
			roles: roles
		)
	end

	def createTaxon(props)
		ranks = {
			'Genus' => 'NomenclaturalRank::Icn::GenusGroup::Genus',
			'Family' => 'NomenclaturalRank::Icn::FamilyGroup::Family',
			'NomenclaturalRank' => 'NomenclaturalRank',
			'Species' => 'NomenclaturalRank::Icn::SpeciesAndInfraspeciesGroup::Species'
		}
		Protonym.create!(
			parent_id: props['parentId'],
			name: props['name'],
			roles: props['authors'].map do |aid|
				TaxonNameAuthor.new(
					person_id: aid,
					position: 'Author'
				)
			end,
			rank_class: ranks[props['rank']],
			source: Source.find(props['source'])
		)
	end

	def createSynonym(props)
		types = {
			'heterotypic (taxonomic) synonym' => 'TaxonNameRelationship::Icn::Unaccepting::Synonym::Heterotypic',
			'synonym' => 'TaxonNameRelationship::Icn::Unaccepting::Synonym'
		}
		TaxonNameRelationship.create!(
			subject_taxon_name_id: props['subjectId'],
			object_taxon_name_id: props['objectId'],
			type: types[props['reason']]
		)
	end

	def getSiteSettings()
		{
			'name' => 'Solanacea Source',
			'theme_color' => 'purple'
		}
	end

	def getTaxonRaw(taxonId)
		Protonym.find(taxonId)
	end

	def getTaxon(taxonId)
		{}
	end

	def getTaxonOverview(taxonId)
		t = getTaxonRaw(taxonId)
		ancestors = t.ancestors_through_parents.drop(1)

		tree = nil

		ancestors.reverse.each do |taxon|
			children = taxon.children.map do |child|
				{
					'name' => child.name,
					'id' => child.id
				}
			end

			if tree then
				children << tree
			end

			tree = {
				'name' => taxon.name,
				'id' => taxon.id,
				'children' => children
			}
		end

		{
			'name' => t.name,
			'authors' => t.author_string,
			'tree' => tree,
			'ancestors' => ancestors.map do |taxon|
				{
					'name' => taxon.name,
					'rank' => taxon.rank_class.rank_name,
					'id' => taxon.id
				}
			end
		}
	end
end
