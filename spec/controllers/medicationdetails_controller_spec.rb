require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe MedicationdetailsController do

  def mock_medicationdetail(stubs={})
    @mock_medicationdetail ||= mock_model(Medicationdetail, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all medicationdetails as @medicationdetails" do
      Medicationdetail.stub(:all) { [mock_medicationdetail] }
      get :index
      assigns(:medicationdetails).should eq([mock_medicationdetail])
    end
  end

  describe "GET show" do
    it "assigns the requested medicationdetail as @medicationdetail" do
      Medicationdetail.stub(:find).with("37") { mock_medicationdetail }
      get :show, :id => "37"
      assigns(:medicationdetail).should be(mock_medicationdetail)
    end
  end

  describe "GET new" do
    it "assigns a new medicationdetail as @medicationdetail" do
      Medicationdetail.stub(:new) { mock_medicationdetail }
      get :new
      assigns(:medicationdetail).should be(mock_medicationdetail)
    end
  end

  describe "GET edit" do
    it "assigns the requested medicationdetail as @medicationdetail" do
      Medicationdetail.stub(:find).with("37") { mock_medicationdetail }
      get :edit, :id => "37"
      assigns(:medicationdetail).should be(mock_medicationdetail)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created medicationdetail as @medicationdetail" do
        Medicationdetail.stub(:new).with({'these' => 'params'}) { mock_medicationdetail(:save => true) }
        post :create, :medicationdetail => {'these' => 'params'}
        assigns(:medicationdetail).should be(mock_medicationdetail)
      end

      it "redirects to the created medicationdetail" do
        Medicationdetail.stub(:new) { mock_medicationdetail(:save => true) }
        post :create, :medicationdetail => {}
        response.should redirect_to(medicationdetail_url(mock_medicationdetail))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved medicationdetail as @medicationdetail" do
        Medicationdetail.stub(:new).with({'these' => 'params'}) { mock_medicationdetail(:save => false) }
        post :create, :medicationdetail => {'these' => 'params'}
        assigns(:medicationdetail).should be(mock_medicationdetail)
      end

      it "re-renders the 'new' template" do
        Medicationdetail.stub(:new) { mock_medicationdetail(:save => false) }
        post :create, :medicationdetail => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested medicationdetail" do
        Medicationdetail.stub(:find).with("37") { mock_medicationdetail }
        mock_medicationdetail.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :medicationdetail => {'these' => 'params'}
      end

      it "assigns the requested medicationdetail as @medicationdetail" do
        Medicationdetail.stub(:find) { mock_medicationdetail(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:medicationdetail).should be(mock_medicationdetail)
      end

      it "redirects to the medicationdetail" do
        Medicationdetail.stub(:find) { mock_medicationdetail(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(medicationdetail_url(mock_medicationdetail))
      end
    end

    describe "with invalid params" do
      it "assigns the medicationdetail as @medicationdetail" do
        Medicationdetail.stub(:find) { mock_medicationdetail(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:medicationdetail).should be(mock_medicationdetail)
      end

      it "re-renders the 'edit' template" do
        Medicationdetail.stub(:find) { mock_medicationdetail(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested medicationdetail" do
      Medicationdetail.stub(:find).with("37") { mock_medicationdetail }
      mock_medicationdetail.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the medicationdetails list" do
      Medicationdetail.stub(:find) { mock_medicationdetail }
      delete :destroy, :id => "1"
      response.should redirect_to(medicationdetails_url)
    end
  end

end
