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

describe CitationsController, type: :controller do
  before(:each) {
    sign_in
  }

  # This should return the minimal set of attributes required to create a valid
  # Citation. As you add validations to Citation, be sure to
  # adjust the attributes here as well.
  # let(:valid_attributes) { strip_housekeeping_attributes(FactoryBot.build(:valid_citation).attributes) }
  let(:o) { FactoryBot.create(:valid_otu) }
  let(:s) { FactoryBot.create(:valid_source) }
  let(:valid_attributes) {
    {citation_object_id: o.id, citation_object_type: o.class.to_s, source_id: s.to_param} }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # CitationsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET index' do
    it 'assigns recent citations as @recentObjects' do
      citation = Citation.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(assigns(:recent_objects)).to include(citation)
    end
  end

  before {
    request.env['HTTP_REFERER'] = otu_path(o)
  }

  describe 'POST create' do

    before {
      request.env['HTTP_REFERER'] = new_citation_path
    }

    describe 'with valid params' do
      it 'creates a new Citation' do
        expect {
          post :create, params: {citation: valid_attributes}, session: valid_session
        }.to change(Citation, :count).by(1)
      end

      it 'assigns a newly created citation as @citation' do
        post :create, params: {citation: valid_attributes}, session: valid_session
        expect(assigns(:citation)).to be_a(Citation)
        expect(assigns(:citation)).to be_persisted
      end

      it 'redirects to :back' do
        post :create, params: {citation: valid_attributes}, session: valid_session

        expect(response).to redirect_to(otu_path(o))
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved citation as @citation' do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Citation).to receive(:save).and_return(false)
        post :create, params: {citation: {source_id: nil}}, session: valid_session
        expect(assigns(:citation)).to be_a_new(Citation)
      end

      it 're-renders the :back template' do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Citation).to receive(:save).and_return(false)
        post :create, params: {citation: {source_id: nil}}, session: valid_session
        expect(response).to redirect_to(new_citation_path)
      end
    end
  end

  describe 'PUT update' do

     before {
      request.env['HTTP_REFERER'] = citation_path(1)
    }
     let(:o) {o = Otu.create(name: 'bar')}
     let(:update_params) {ActionController::Parameters.new({citation_object_type: 'Otu', 'citation_object_id' => o.id.to_s}).permit(:citation_object_type, :citation_object_id)}

     describe 'with valid params' do
      it 'updates the requested citation' do
        citation = Citation.create! valid_attributes
        # Assuming there are no other citations in the database, this
        # specifies that the Citation created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        # o = Otu.create(name: 'bar')
        # expect_any_instance_of(Citation).to receive(:update).with({'citation_object_type' => 'Otu', 'citation_object_id' => o.id.to_s})
        expect_any_instance_of(Citation).to receive(:update).with(update_params)
        put :update, params: {id: citation.to_param, :citation => {citation_object_type: 'Otu', citation_object_id: o.id}}, session: valid_session
      end

      it 'assigns the requested citation as @citation' do
        citation = Citation.create! valid_attributes
        put :update, params: {id: citation.to_param, :citation => valid_attributes}, session: valid_session
        expect(assigns(:citation)).to eq(citation)
      end

      it 'redirects to :back' do
        citation = Citation.create! valid_attributes
        put :update, params: {id: citation.to_param, :citation => valid_attributes}, session: valid_session
        expect(response).to redirect_to(otu_path(o))
      end
    end

    describe 'with invalid params' do
      it 'assigns the citation as @citation' do
        citation = Citation.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Citation).to receive(:save).and_return(false)
        put :update, params: {id: citation.to_param, :citation => {source_id: nil}}, session: valid_session
        expect(assigns(:citation)).to eq(citation)
      end

      it 're-renders the :back template' do
        citation = Citation.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Citation).to receive(:save).and_return(false)
        put :update, params: {id: citation.to_param, :citation => {source_id: nil}}, session: valid_session
        expect(response).to redirect_to(citation_path(1))
      end
    end
  end

  describe 'DELETE destroy' do

    before {
      request.env['HTTP_REFERER'] = otu_path(o)
    }

    it 'destroys the requested citation' do
      citation = Citation.create! valid_attributes
      expect {
        delete :destroy, params: {id: citation.to_param}, session: valid_session
      }.to change(Citation, :count).by(-1)
    end

    it 'redirects to :back' do
      citation = Citation.create! valid_attributes
      delete :destroy, params: {id: citation.to_param}, session: valid_session
      expect(response).to redirect_to(otu_path(o))
    end
  end

end
