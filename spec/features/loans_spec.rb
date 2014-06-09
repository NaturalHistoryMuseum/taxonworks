require 'spec_helper'

describe 'Loans', base_class: Loan do

  it_behaves_like 'a_login_required_and_project_selected_controller'

  describe 'GET /loans' do
    before { visit loans_path }
    specify 'an index name is present' do
      expect(page).to have_content('Loans')
    end
  end
end
