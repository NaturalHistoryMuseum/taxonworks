require 'spec_helper'

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

describe GeoreferencesController do

  # This should return the minimal set of attributes required to create a valid
  # Georeference. As you add validations to Georeference, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { FactoryGirl.build(:valid_georeference).attributes }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # GeoreferencesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all georeferences as @georeferences" do
      georeference = Georeference.create! valid_attributes
      get :index, {}, valid_session
      assigns(:georeferences).should eq([georeference])
    end
  end

  describe "GET show" do
    it "assigns the requested georeference as @georeference" do
      georeference = Georeference.create! valid_attributes
      get :show, {:id => georeference.to_param}, valid_session
      assigns(:georeference).should eq(georeference)
    end
  end

  describe "GET new" do
    it "assigns a new georeference as @georeference" do
      get :new, {}, valid_session
      assigns(:georeference).should be_a_new(Georeference)
    end
  end

  describe "GET edit" do
    it "assigns the requested georeference as @georeference" do
      georeference = Georeference.create! valid_attributes
      get :edit, {:id => georeference.to_param}, valid_session
      assigns(:georeference).should eq(georeference)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Georeference" do
        expect {
          post :create, {:georeference => valid_attributes}, valid_session
        }.to change(Georeference, :count).by(1)
      end

      it "assigns a newly created georeference as @georeference" do
        post :create, {:georeference => valid_attributes}, valid_session
        assigns(:georeference).should be_a(Georeference)
        assigns(:georeference).should be_persisted
      end

      it "redirects to the created georeference" do
        post :create, {:georeference => valid_attributes}, valid_session
        response.should redirect_to(Georeference.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved georeference as @georeference" do
        # Trigger the behavior that occurs when invalid params are submitted
        Georeference.any_instance.stub(:save).and_return(false)
        post :create, {:georeference => { "geographic_item_id" => "invalid value" }}, valid_session
        assigns(:georeference).should be_a_new(Georeference)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Georeference.any_instance.stub(:save).and_return(false)
        post :create, {:georeference => { "geographic_item_id" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested georeference" do
        georeference = Georeference.create! valid_attributes
        # Assuming there are no other georeferences in the database, this
        # specifies that the Georeference created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Georeference.any_instance.should_receive(:update).with({ "geographic_item_id" => "1" })
        put :update, {:id => georeference.to_param, :georeference => { "geographic_item_id" => "1" }}, valid_session
      end

      it "assigns the requested georeference as @georeference" do
        georeference = Georeference.create! valid_attributes
        put :update, {:id => georeference.to_param, :georeference => valid_attributes}, valid_session
        assigns(:georeference).should eq(georeference)
      end

      it "redirects to the georeference" do
        georeference = Georeference.create! valid_attributes
        put :update, {:id => georeference.to_param, :georeference => valid_attributes}, valid_session
        response.should redirect_to(georeference)
      end
    end

    describe "with invalid params" do
      it "assigns the georeference as @georeference" do
        georeference = Georeference.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Georeference.any_instance.stub(:save).and_return(false)
        put :update, {:id => georeference.to_param, :georeference => { "geographic_item_id" => "invalid value" }}, valid_session
        assigns(:georeference).should eq(georeference)
      end

      it "re-renders the 'edit' template" do
        georeference = Georeference.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Georeference.any_instance.stub(:save).and_return(false)
        put :update, {:id => georeference.to_param, :georeference => { "geographic_item_id" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested georeference" do
      georeference = Georeference.create! valid_attributes
      expect {
        delete :destroy, {:id => georeference.to_param}, valid_session
      }.to change(Georeference, :count).by(-1)
    end

    it "redirects to the georeferences list" do
      georeference = Georeference.create! valid_attributes
      delete :destroy, {:id => georeference.to_param}, valid_session
      response.should redirect_to(georeferences_url)
    end
  end

end
