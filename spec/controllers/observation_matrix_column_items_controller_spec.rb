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

RSpec.describe ObservationMatrixColumnItemsController, type: :controller do
  before { sign_in }
  # This should return the minimal set of attributes required to create a valid
  # ObservationMatrixColumnItemsController. As you add validations to ObservationMatrixColumnItemsController, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    strip_housekeeping_attributes(FactoryGirl.build(:valid_observation_matrix_column_item).attributes)
  }

  let(:invalid_attributes) {
    valid_attributes.merge('observation_matrix_id' => nil)
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ObservationMatrixColumnItemsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns recent observation_matrix_column_items as @recent_objects" do
      observation_matrix_column_item = ObservationMatrixColumnItem.create! valid_attributes
      get :index, {}, session: valid_session
      expect(assigns(:recent_objects)).to eq([observation_matrix_column_item])
    end
  end

  describe "GET #show" do
    it "assigns the requested observation_matrix_column_item as @observation_matrix_column_item" do
      observation_matrix_column_item = ObservationMatrixColumnItem.create! valid_attributes
      get :show, {id: observation_matrix_column_item.to_param}, session: valid_session
      expect(assigns(:observation_matrix_column_item)).to eq(observation_matrix_column_item)
    end
  end

  describe "GET #new" do
    it "assigns a new observation_matrix_column_item as @observation_matrix_column_item" do
      get :new, {}, session: valid_session
      expect(assigns(:observation_matrix_column_item)).to be_a_new(ObservationMatrixColumnItem)
    end
  end

  describe "GET #edit" do
    it "assigns the requested observation_matrix_column_item as @observation_matrix_column_item" do
      observation_matrix_column_item = ObservationMatrixColumnItem.create! valid_attributes
      get :edit, {id: observation_matrix_column_item.to_param}, session: valid_session
      expect(assigns(:observation_matrix_column_item)).to eq(observation_matrix_column_item)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new ObservationMatrixColumnItemsController" do
        expect {
          post :create, {observation_matrix_column_item: valid_attributes}, session: valid_session
        }.to change(ObservationMatrixColumnItem, :count).by(1)
      end

      it "assigns a newly created observation_matrix_column_item as @observation_matrix_column_item" do
        post :create, {observation_matrix_column_item: valid_attributes}, session: valid_session
        expect(assigns(:observation_matrix_column_item)).to be_a(ObservationMatrixColumnItem)
        expect(assigns(:observation_matrix_column_item)).to be_persisted
      end

      it "redirects to the created observation_matrix_column_item" do
        post :create, {observation_matrix_column_item: valid_attributes}, session: valid_session
        expect(response).to redirect_to(ObservationMatrixColumnItem.last.metamorphosize)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved observation_matrix_column_item as @observation_matrix_column_item" do
        post :create, params: {observation_matrix_column_item: invalid_attributes}, session: valid_session
        expect(assigns(:observation_matrix_column_item).metamorphosize).to be_a_new(ObservationMatrixColumnItem)
      end

      it "re-renders the 'new' template" do
        post :create, params: {observation_matrix_column_item: invalid_attributes}, session: valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested observation_matrix_column_item" do
        observation_matrix_column_item = ObservationMatrixColumnItem.create! valid_attributes
        m = FactoryGirl.create(:valid_observation_matrix)
        put :update, {id: observation_matrix_column_item.to_param, observation_matrix_column_item: {observation_matrix_id: m.id}}, session: valid_session
        observation_matrix_column_item.reload
        expect(observation_matrix_column_item.observation_matrix_id).to eq(m.id)
      end

      it "assigns the requested observation_matrix_column_item as @observation_matrix_column_item" do
        observation_matrix_column_item = ObservationMatrixColumnItem.create! valid_attributes
        put :update, {id: observation_matrix_column_item.to_param, observation_matrix_column_item: valid_attributes}, session: valid_session
        expect(assigns(:observation_matrix_column_item)).to eq(observation_matrix_column_item)
      end

      it "redirects to the observation_matrix_column_item" do
        observation_matrix_column_item = ObservationMatrixColumnItem.create! valid_attributes
        put :update, {id: observation_matrix_column_item.to_param, observation_matrix_column_item: valid_attributes}, session: valid_session
        expect(response).to redirect_to(observation_matrix_column_item.metamorphosize)
      end
    end

    context "with invalid params" do
      it "assigns the observation_matrix_column_item as @observation_matrix_column_item" do
        observation_matrix_column_item = ObservationMatrixColumnItem.create! valid_attributes
        put :update, {id: observation_matrix_column_item.to_param, observation_matrix_column_item: invalid_attributes}, session: valid_session
        expect(assigns(:observation_matrix_column_item)).to eq(observation_matrix_column_item)
      end

      it "re-renders the 'edit' template" do
        observation_matrix_column_item = ObservationMatrixColumnItem.create! valid_attributes
        put :update, params: {id: observation_matrix_column_item.to_param, observation_matrix_column_item: invalid_attributes}, session: valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested observation_matrix_column_item" do
      observation_matrix_column_item = ObservationMatrixColumnItem.create! valid_attributes
      expect {
        delete :destroy, {id: observation_matrix_column_item.to_param}, session: valid_session
      }.to change(ObservationMatrixColumnItem, :count).by(-1)
    end

    it "redirects to the observation_matrix_column_items list" do
      observation_matrix_column_item = ObservationMatrixColumnItem.create! valid_attributes
      delete :destroy, {id: observation_matrix_column_item.to_param}, session: valid_session
      expect(response).to redirect_to(observation_matrix_column_items_url)
    end
  end

end
