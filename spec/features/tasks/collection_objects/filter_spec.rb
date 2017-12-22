require 'rails_helper'
require 'make_simple_world'

describe 'tasks/collection_objects/filter', type: :feature, group: [:geo, :collection_objects] do

  context 'with properly built collection of objects' do
    let(:page_title) { 'Collection objects by area and date' }
    let(:index_path) { collection_objects_filter_task_path }

    it_behaves_like 'a_login_required_and_project_selected_controller'

    context 'signed in as a user' do
      before {
        sign_in_user_and_select_project
        simple_world(@user.id, @project.id)
      }
      # need some people
      let(:sargon) { Person.where(first_name: 'of Akkad', last_name: 'Sargon').first }
      let(:andy) { Person.where(first_name: 'Andy', last_name: 'Worehall', prefix: 'Non-author').first }
      let(:daryl) { Person.where(first_name: 'Daryl', last_name: 'Penfold', prefix: 'with Sargon').first }
      let(:ted) { Person.where(last_name: 'Pomaroy', first_name: 'Ted', prefix: 'HEWIC').first }
      let(:bill) { Person.where(first_name: 'Bill', last_name: 'Ardson').first }

      # need some otus
      let(:top_dog) { Otu.where(name: 'Top Dog').first }
      let(:nuther_dog) { Otu.where(name: 'Another Dog').first }
      let(:spooler) { Otu.where('name like ?', '%spooler%').first }
      let(:p4) { Otu.where(name: 'P4').first }
      let(:by_bill) { Otu.where('name like ?', '%by Bill%').first }
      let(:otu_a) { Otu.where(name: 'Otu_A').first }
      let(:abra) { Otu.where(name: 'Abra').first }
      let(:cadabra) { Otu.where('name like ?', '%cadabra%').first }
      let(:alakazam) { Otu.where('name like ?', '%alakazam%').first }

      # need some areas
      let(:area_a) { GeographicArea.where(name: 'A').first }
      let(:area_b) { GeographicArea.where(name: 'B').first }
      let(:area_e) { GeographicArea.where(name: 'E').first }
      let(:json_string) { '{"type":"Feature", "properties":{}, "geometry":{"type":"MultiPolygon", "coordinates":[[[[0, 10, 0], [10, 10, 0], [10, -10, 0], [0, -10, 0], [0, 10, 0]]]]}}' }

      # need some collection objects
      let(:co_a) {
        object = CollectingEvent.where(verbatim_label: 'Eh?').first
        object.collection_objects.first
      }

      let(:co_b) {
        object = CollectingEvent.where(verbatim_label: 'Bah').first
        object.collection_objects.first
      }



      context 'triggering the by_otu facet' do
        describe '#set_otu', js: true, resolution: true do
          let(:otu_test) { Otu.create!(name: 'zzzzz', by: @user, project: @project) }
          let(:specimen) { Specimen.create!(by: @user, project: @project) }

          before do
            # can't use `a = specimen.otus << otu_test` because $user_id and $project_id don't exist.
            TaxonDetermination.create!(otu: otu_test, biological_collection_object: specimen, by: @user, project: @project)
            visit(collection_objects_filter_task_path)
          end

          it 'renders count of collection objects based on a selected otu' do
            fill_autocomplete('otu_id_for_by_otu', with: otu_test.name, select: otu_test.to_param)
            wait_for_ajax
            find('#set_otu').click
            wait_for_ajax
            expect(find('#otu_count')).to have_text('1', wait: 10)
          end
        end
      end

      context 'triggering the by_identifier facet' do
        describe '#set_identifier', js: true, resolution: true do

          before do
            2.times { FactoryBot.create(:valid_namespace, creator: @user, updater: @user) }
            ns1 = Namespace.first
            ns2 = Namespace.second
            2.times { FactoryBot.create(:valid_specimen, creator: @user, updater: @user, project: @project) }
            (1..10).each { |identifier|
              sp = FactoryBot.create(:valid_specimen, creator: @user, updater: @user, project: @project)
              id = FactoryBot.create(:identifier_local_catalog_number,
                                      updater:           @user,
                                      project:           @project,
                                      creator:           @user,
                                      identifier_object: sp,
                                      namespace:         ((identifier % 2) == 0 ? ns1 : ns2),
                                      identifier:        identifier)
            }
            visit(collection_objects_filter_task_path)
          end

          it 'renders the count of collection objects based on a selected range of identifiers' do
            expect(Specimen.count).to eq(14)
            expect(Identifier.count).to eq(10)
            expect(Namespace.count).to eq(2)
            # expect(true).to be_truthy
          end
        end
      end

      context 'with some records created' do

        describe '#set_area', js: true do #
          it 'renders count of collection objects in a specific names area' do
            visit(collection_objects_filter_task_path)
            fill_area_picker_autocomplete('area_picker_autocomplete', with: 'E', select: area_e.id)
            click_button('Set area')
            expect(find('#area_count')).to have_text('2')
          end

          it 'renders count of collection objects in a drawn area' do
            visit(collection_objects_filter_task_path)
            find('#label_toggle_slide_area').click
            execute_script("document.getElementById('drawn_area_shape').type = 'text'")
            this_xpath = find(:xpath, "//input[@id='drawn_area_shape']")
            this_xpath.set json_string
            click_button('Set area')
            expect(find('#area_count')).to have_text('2')
          end
        end

        describe '#set_date', js: true do
          before { visit(collection_objects_filter_task_path) }
          it 'renders count of collection objects based on the start and end dates' do
            execute_script("document.getElementById('search_end_date').value = '1980-12-31'")
            find('#search_start_date').set('1971-01-01')
            find('#set_date').click
            expect(find('#date_count')).to have_content('1')
          end
        end

        describe '#find', js: true do
          before {
            visit(collection_objects_filter_task_path)
            execute_script("document.getElementById('search_start_date').value = '1971-01-01'")
            execute_script("document.getElementById('search_end_date').value = '1980-12-31'")
            #  find('#search_start_date').set '1971/01/01'
            #  find('#search_end_date').set '1980/12/31'
            find('#label_toggle_slide_area').click
            wait_for_ajax
            execute_script("document.getElementById('drawn_area_shape').type = 'text'")
            this_xpath = find(:xpath, "//input[@id='drawn_area_shape']")
            this_xpath.set json_string
            click_button('Set area')
            wait_for_ajax
            find('#find_area_and_date_commit').click
            # find('#result_span', visible: false, text: '10')
            find('#area_count', visible: true, text: '2')
            # expect(true).to be_truthy
          }

          it 'renders count of objects and table found using a drawn area and date range' do
            expect(find(:xpath, "//div['show_list']/table[@class='tablesorter']/thead")).to have_text('Catalog Number')
          end

        end
      end

      context 'with records specific to identifiers' do
        describe 'select a namespace', js: true do
          it 'should find the correct namespace' do
            @ns1 = FactoryBot.create(:valid_namespace, creator: @user, updater: @user)
            @ns2 = FactoryBot.create(:valid_namespace, creator: @user, updater: @user, short_name: 'PSUC_FEM')
            visit(collection_objects_filter_task_path)

            expect(page).to have_button('Set Identifier Range')
            select('PSUC', from: 'id_namespace')
            # s = find(:select, 'id_namespace')
            # s.send_keys("P\t")
            expect(page).to have_text('PSUC_FEM')
          end
        end

        describe 'select start and stop identifiers', js: true do
          it 'should find the start and stop inputs' do
            @ns1 = FactoryBot.create(:valid_namespace, creator: @user, updater: @user)
            @ns2 = FactoryBot.create(:valid_namespace, creator: @user, updater: @user, short_name: 'PSUC_FEM')
            3.times { FactoryBot.create(:valid_namespace, creator: @user, updater: @user) }
            @ns3 = Namespace.third
            2.times { FactoryBot.create(:valid_specimen, creator: @user, updater: @user, project: @project) }
            FactoryBot.create(:identifier_local_import,
                               identifier_object: Specimen.first,
                               namespace:         @ns3,
                               identifier:        'First specimen', creator: @user, updater: @user, project: @project)
            FactoryBot.create(:identifier_local_import,
                               identifier_object: Specimen.second,
                               namespace:         @ns3,
                               identifier:        'Second specimen', creator: @user, updater: @user, project: @project)
            (1..10).each { |identifier|
              sp = FactoryBot.create(:valid_specimen, creator: @user, updater: @user, project: @project)
              id = FactoryBot.create(:identifier_local_catalog_number,
                                      identifier_object: sp,
                                      namespace:         ((identifier % 2) == 0 ? @ns1 : @ns2),
                                      identifier:        identifier, creator: @user, updater: @user, project: @project)
            }

            expect(Specimen.with_identifier('PSUC_FEM 1').count).to eq(1)
            expect(Specimen.with_namespaced_identifier('PSUC_FEM', 2).count).to eq(0)
            expect(Specimen.with_namespaced_identifier('PSUC_FEM', 3).count).to eq(1)
            visit(collection_objects_filter_task_path)

            page.execute_script "$('#set_id_range')[0].scrollIntoView()"

            fill_in('id_range_start', with: '1')
            fill_in('id_range_stop', with: '10')

            click_button('Set Identifier Range', {id: 'set_id_range'})
            wait_for_ajax
            expect(find('#id_range_count')).to have_content('10')

            fill_in('id_range_start', with: '3')
            fill_in('id_range_stop', with: '8')

            click_button('Set Identifier Range', {id: 'set_id_range'})
            wait_for_ajax
            expect(find('#id_range_count')).to have_content('6')

            fill_in('id_range_start', with: '8')
            fill_in('id_range_stop', with: '3')

            click_button('Set Identifier Range', {id: 'set_id_range'})
            wait_for_ajax
            expect(find('#id_range_count')).to have_content('0')

            select('PS', from: 'id_namespace')
            fill_in('id_range_start', with: '3')
            fill_in('id_range_stop', with: '9')

            click_button('Set Identifier Range', {id: 'set_id_range'})
            wait_for_ajax
            expect(find('#id_range_count')).to have_content('4')

            find('#find_area_and_date_commit').click
            wait_for_ajax
            expect(find('#paging_data')).to have_content('all 4')

          end
        end
      end

      context 'with records specific to users and dates' do
        let(:pat) { User.find(1) }
        let(:pat_admin) { User.where(name: 'Pat Project Administrator').first }
        let!(:joe) {
          peep = FactoryBot.create(:valid_user, by: pat_admin)
          ProjectMember.create(project_id: @project.id, user_id: peep.id, by: pat_admin)
          peep
        }

        describe 'default user', js: true do
          it 'should present the current user' do
            visit(collection_objects_filter_task_path)
            page.execute_script "$('#set_user_date_range')[0].scrollIntoView()"

            expect(page).to have_button('Set User/Date Range')
            expect(page).to have_text(@user.name)
          end
        end

        describe 'selected user', js: true do
          it 'should find specific user' do
            visit(collection_objects_filter_task_path)
            page.execute_script "$('#set_user_date_range')[0].scrollIntoView()"

            select('Joe', from: 'user')
            expect(find_field('user').value).to eq(joe.id.to_s)
          end
        end

        describe 'selected objects', js: true do
          it 'should find specific objects' do
            2.times { FactoryBot.create(:valid_specimen, creator: pat_admin, updater: pat_admin, project: @project) }
            (1..10).each { |specimen|
              sp = FactoryBot.create(:valid_specimen,
                                      creator:    ((specimen % 2) == 0 ? joe : pat),
                                      created_at: "200#{specimen - 1}/01/#{specimen}",
                                      updated_at: "200#{specimen - 1}/07/#{specimen}",
                                      updater:    ((specimen % 2) == 0 ? pat : joe),
                                      project:    @project)
            }

            expect(Specimen.created_by_user(pat_admin).count).to eq(2)
            expect(Specimen.created_by_user(pat).count).to eq(7)
            expect(Specimen.created_by_user(joe).count).to eq(5)

            visit(collection_objects_filter_task_path)

            page.execute_script "$('#set_user_date_range')[0].scrollIntoView()"

            # default select is current user / all dates
            click_button('Set User/Date Range', {id: 'set_user_date_range'})
            wait_for_ajax
            expect(find('#user_date_range_count')).to have_content('7')

            select('All users', from: 'user')
            click_button('Set User/Date Range', {id: 'set_user_date_range'})
            wait_for_ajax
            expect(find('#user_date_range_count')).to have_content('14')

            fill_in('user_date_range_start', with: '2005-01-01')
            fill_in('user_date_range_end', with: Date.yesterday)

            click_button('Set User/Date Range', {id: 'set_user_date_range'})
            wait_for_ajax
            expect(find('#user_date_range_count')).to have_content('5')

            select('Pat Pro', from: 'user')
            fill_in('user_date_range_start', with: Date.today)
            fill_in('user_date_range_end', with: Date.today)

            click_button('Set User/Date Range', {id: 'set_user_date_range'})
            wait_for_ajax
            expect(find('#user_date_range_count')).to have_content('2')

            fill_in('user_date_range_start', with: Date.yesterday)
            fill_in('user_date_range_end', with: Date.yesterday)

            click_button('Set User/Date Range', {id: 'set_user_date_range'})
            wait_for_ajax
            expect(find('#user_date_range_count')).to have_content('0')

          end
        end
      end
    end
  end
end

