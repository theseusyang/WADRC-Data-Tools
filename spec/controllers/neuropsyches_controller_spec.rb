require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe NeuropsychesController do

  def mock_neuropsych(stubs={})
    @mock_neuropsych ||= mock_model(Neuropsych, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all neuropsyches as @neuropsyches" do
      Neuropsych.stub(:all) { [mock_neuropsych] }
      get :index
      assigns(:neuropsyches).should eq([mock_neuropsych])
    end
  end

  describe "GET show" do
    it "assigns the requested neuropsych as @neuropsych" do
      Neuropsych.stub(:find).with("37") { mock_neuropsych }
      get :show, :id => "37"
      assigns(:neuropsych).should be(mock_neuropsych)
    end
  end

  describe "GET new" do
    it "assigns a new neuropsych as @neuropsych" do
      Neuropsych.stub(:new) { mock_neuropsych }
      get :new
      assigns(:neuropsych).should be(mock_neuropsych)
    end
  end

  describe "GET edit" do
    it "assigns the requested neuropsych as @neuropsych" do
      Neuropsych.stub(:find).with("37") { mock_neuropsych }
      get :edit, :id => "37"
      assigns(:neuropsych).should be(mock_neuropsych)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created neuropsych as @neuropsych" do
        Neuropsych.stub(:new).with({'these' => 'params'}) { mock_neuropsych(:save => true) }
        post :create, :neuropsych => {'these' => 'params'}
        assigns(:neuropsych).should be(mock_neuropsych)
      end

      it "redirects to the created neuropsych" do
        Neuropsych.stub(:new) { mock_neuropsych(:save => true) }
        post :create, :neuropsych => {}
        response.should redirect_to(neuropsych_url(mock_neuropsych))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved neuropsych as @neuropsych" do
        Neuropsych.stub(:new).with({'these' => 'params'}) { mock_neuropsych(:save => false) }
        post :create, :neuropsych => {'these' => 'params'}
        assigns(:neuropsych).should be(mock_neuropsych)
      end

      it "re-renders the 'new' template" do
        Neuropsych.stub(:new) { mock_neuropsych(:save => false) }
        post :create, :neuropsych => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested neuropsych" do
        Neuropsych.stub(:find).with("37") { mock_neuropsych }
        mock_neuropsych.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :neuropsych => {'these' => 'params'}
      end

      it "assigns the requested neuropsych as @neuropsych" do
        Neuropsych.stub(:find) { mock_neuropsych(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:neuropsych).should be(mock_neuropsych)
      end

      it "redirects to the neuropsych" do
        Neuropsych.stub(:find) { mock_neuropsych(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(neuropsych_url(mock_neuropsych))
      end
    end

    describe "with invalid params" do
      it "assigns the neuropsych as @neuropsych" do
        Neuropsych.stub(:find) { mock_neuropsych(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:neuropsych).should be(mock_neuropsych)
      end

      it "re-renders the 'edit' template" do
        Neuropsych.stub(:find) { mock_neuropsych(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested neuropsych" do
      Neuropsych.stub(:find).with("37") { mock_neuropsych }
      mock_neuropsych.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the neuropsyches list" do
      Neuropsych.stub(:find) { mock_neuropsych }
      delete :destroy, :id => "1"
      response.should redirect_to(neuropsyches_url)
    end
  end

end
