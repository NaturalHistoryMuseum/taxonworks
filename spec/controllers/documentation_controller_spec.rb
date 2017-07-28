require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe DocumentationController, type: :controller do
  before(:each) {
    sign_in
  }

  # This should return the minimal set of attributes required to create a valid
  # Documentation. As you add validations to Documentation, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { strip_housekeeping_attributes(FactoryGirl.build(:valid_documentation).attributes) }

  let(:documentation_target) { FactoryGirl.create(:valid_collecting_event) }
  let(:document) { FactoryGirl.create(:valid_document) }

  let(:creatable_documentation) {
    FactoryGirl.create(:valid_documentation, {type:                      Documentation::CollectingEventDocumentation,
                                              document_id:               document.id,
                                              documentation_object_id:   documentation_target.id,
                                              documentation_object_type: documentation_target.class}) }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # DocumentationController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'assigns all recent documentation as @recent_objects' do
      documentation = Documentation.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(assigns(:recent_objects)).to eq([documentation])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested documentation as @documentation' do
      documentation = Documentation.create! valid_attributes
      get :show, params: {id: documentation.to_param}, session: valid_session
      expect(assigns(:documentation)).to eq(documentation)
    end
  end

  describe 'GET #new' do
    it 'assigns a new documentation as @documentation' do
      get :new, params: {}, session: valid_session
      expect(assigns(:documentation)).to be_a_new(Documentation)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested documentation as @documentation' do
      documentation = Documentation.create! valid_attributes
      get :edit, params: {id: documentation.to_param}, session: valid_session
      expect(assigns(:documentation)).to eq(documentation)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Documentation' do
        expect {
          post :create, params: {documentation: valid_attributes}, session: valid_session
        }.to change(Documentation, :count).by(1)
      end

      it 'assigns a newly created documentation as @documentation' do
        post :create, params: {documentation: valid_attributes}, session: valid_session
        expect(assigns(:documentation)).to be_a(Documentation)
        expect(assigns(:documentation)).to be_persisted
      end

      it 'redirects to the created documentation' do
        post :create, params: {documentation: valid_attributes}, session: valid_session
        expect(response).to redirect_to(Documentation.last.metamorphosize)
      end
    end

    # TODO: @mjy need to re-define the validation process in the face of accepts_nested_attributes
    context 'with invalid params' do
      it 'assigns a newly created but unsaved documentation as @documentation' do
        post :create, params: {documentation: {documentation_object_id: 1}}, session: valid_session
        expect(assigns(:documentation)).to be_a_new(Documentation)
      end

      it 're-renders the \'new\' template' do
        post :create, params: {documentation: {documentation_object_id: 1}}, session: valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) {
        skip('Add a hash of attributes valid for your model')
      }

      # it 'updates the requested documentation' do
      #   documentation = Documentation.create! valid_attributes
      #   put :update, {id: documentation.to_param, documentation: new_attributes}, session: valid_session
      #   documentation.reload
      #   skip('Add assertions for updated state')
      # end

      it 'assigns the requested documentation as @documentation' do
        documentation = Documentation.create! valid_attributes
        put :update, params: {id: documentation.to_param, documentation: valid_attributes}, session: valid_session
        expect(assigns(:documentation)).to eq(documentation)
      end

      it 'redirects to the documentation' do
        documentation = Documentation.create! valid_attributes
        put :update, params: {id: documentation.to_param, documentation: valid_attributes}, session: valid_session
        expect(response).to redirect_to(documentation.metamorphosize)
      end
    end

    context 'with invalid params' do
      it 'assigns the documentation as @documentation' do
        documentation = Documentation.create! valid_attributes
        put :update, params: {id: documentation.to_param, documentation: {documentation_object_id: 1}}, session: valid_session
        expect(assigns(:documentation)).to eq(documentation)
      end

      it 're-renders the \'edit\' template' do
        documentation = Documentation.create! valid_attributes
        put :update, params: {id: documentation.to_param, documentation: {documentation_object_id: nil}}, session: valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested documentation' do
      documentation = Documentation.create! valid_attributes
      expect {
        delete :destroy, params: {id: documentation.to_param}, session: valid_session
      }.to change(Documentation, :count).by(-1)
    end

    it 'redirects to the documentation list' do
      documentation = Documentation.create! valid_attributes
      delete :destroy, params: {id: documentation.to_param}, session: valid_session
      expect(response).to redirect_to(documentation_index_url)
    end
  end
end
