require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe PetscansController do

  def mock_petscan(stubs={})
    @mock_petscan ||= mock_model(Petscan, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all petscans as @petscans" do
      Petscan.stub(:all) { [mock_petscan] }
      get :index
      assigns(:petscans).should eq([mock_petscan])
    end
  end

  describe "GET show" do
    it "assigns the requested petscan as @petscan" do
      Petscan.stub(:find).with("37") { mock_petscan }
      get :show, :id => "37"
      assigns(:petscan).should be(mock_petscan)
    end
  end

  describe "GET new" do
    it "assigns a new petscan as @petscan" do
      Petscan.stub(:new) { mock_petscan }
      get :new
      assigns(:petscan).should be(mock_petscan)
    end
  end

  describe "GET edit" do
    it "assigns the requested petscan as @petscan" do
      Petscan.stub(:find).with("37") { mock_petscan }
      get :edit, :id => "37"
      assigns(:petscan).should be(mock_petscan)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created petscan as @petscan" do
        Petscan.stub(:new).with({'these' => 'params'}) { mock_petscan(:save => true) }
        post :create, :petscan => {'these' => 'params'}
        assigns(:petscan).should be(mock_petscan)
      end

      it "redirects to the created petscan" do
        Petscan.stub(:new) { mock_petscan(:save => true) }
        post :create, :petscan => {}
        response.should redirect_to(petscan_url(mock_petscan))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved petscan as @petscan" do
        Petscan.stub(:new).with({'these' => 'params'}) { mock_petscan(:save => false) }
        post :create, :petscan => {'these' => 'params'}
        assigns(:petscan).should be(mock_petscan)
      end

      it "re-renders the 'new' template" do
        Petscan.stub(:new) { mock_petscan(:save => false) }
        post :create, :petscan => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested petscan" do
        Petscan.stub(:find).with("37") { mock_petscan }
        mock_petscan.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :petscan => {'these' => 'params'}
      end

      it "assigns the requested petscan as @petscan" do
        Petscan.stub(:find) { mock_petscan(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:petscan).should be(mock_petscan)
      end

      it "redirects to the petscan" do
        Petscan.stub(:find) { mock_petscan(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(petscan_url(mock_petscan))
      end
    end

    describe "with invalid params" do
      it "assigns the petscan as @petscan" do
        Petscan.stub(:find) { mock_petscan(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:petscan).should be(mock_petscan)
      end

      it "re-renders the 'edit' template" do
        Petscan.stub(:find) { mock_petscan(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested petscan" do
      Petscan.stub(:find).with("37") { mock_petscan }
      mock_petscan.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the petscans list" do
      Petscan.stub(:find) { mock_petscan }
      delete :destroy, :id => "1"
      response.should redirect_to(petscans_url)
    end
  end

end
