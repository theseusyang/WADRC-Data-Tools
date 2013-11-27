require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe LookupConsentformsController do

  def mock_lookup_consentform(stubs={})
    @mock_lookup_consentform ||= mock_model(LookupConsentform, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all lookup_consentforms as @lookup_consentforms" do
      LookupConsentform.stub(:all) { [mock_lookup_consentform] }
      get :index
      assigns(:lookup_consentforms).should eq([mock_lookup_consentform])
    end
  end

  describe "GET show" do
    it "assigns the requested lookup_consentform as @lookup_consentform" do
      LookupConsentform.stub(:find).with("37") { mock_lookup_consentform }
      get :show, :id => "37"
      assigns(:lookup_consentform).should be(mock_lookup_consentform)
    end
  end

  describe "GET new" do
    it "assigns a new lookup_consentform as @lookup_consentform" do
      LookupConsentform.stub(:new) { mock_lookup_consentform }
      get :new
      assigns(:lookup_consentform).should be(mock_lookup_consentform)
    end
  end

  describe "GET edit" do
    it "assigns the requested lookup_consentform as @lookup_consentform" do
      LookupConsentform.stub(:find).with("37") { mock_lookup_consentform }
      get :edit, :id => "37"
      assigns(:lookup_consentform).should be(mock_lookup_consentform)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created lookup_consentform as @lookup_consentform" do
        LookupConsentform.stub(:new).with({'these' => 'params'}) { mock_lookup_consentform(:save => true) }
        post :create, :lookup_consentform => {'these' => 'params'}
        assigns(:lookup_consentform).should be(mock_lookup_consentform)
      end

      it "redirects to the created lookup_consentform" do
        LookupConsentform.stub(:new) { mock_lookup_consentform(:save => true) }
        post :create, :lookup_consentform => {}
        response.should redirect_to(lookup_consentform_url(mock_lookup_consentform))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved lookup_consentform as @lookup_consentform" do
        LookupConsentform.stub(:new).with({'these' => 'params'}) { mock_lookup_consentform(:save => false) }
        post :create, :lookup_consentform => {'these' => 'params'}
        assigns(:lookup_consentform).should be(mock_lookup_consentform)
      end

      it "re-renders the 'new' template" do
        LookupConsentform.stub(:new) { mock_lookup_consentform(:save => false) }
        post :create, :lookup_consentform => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested lookup_consentform" do
        LookupConsentform.stub(:find).with("37") { mock_lookup_consentform }
        mock_lookup_consentform.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :lookup_consentform => {'these' => 'params'}
      end

      it "assigns the requested lookup_consentform as @lookup_consentform" do
        LookupConsentform.stub(:find) { mock_lookup_consentform(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:lookup_consentform).should be(mock_lookup_consentform)
      end

      it "redirects to the lookup_consentform" do
        LookupConsentform.stub(:find) { mock_lookup_consentform(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(lookup_consentform_url(mock_lookup_consentform))
      end
    end

    describe "with invalid params" do
      it "assigns the lookup_consentform as @lookup_consentform" do
        LookupConsentform.stub(:find) { mock_lookup_consentform(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:lookup_consentform).should be(mock_lookup_consentform)
      end

      it "re-renders the 'edit' template" do
        LookupConsentform.stub(:find) { mock_lookup_consentform(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested lookup_consentform" do
      LookupConsentform.stub(:find).with("37") { mock_lookup_consentform }
      mock_lookup_consentform.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the lookup_consentforms list" do
      LookupConsentform.stub(:find) { mock_lookup_consentform }
      delete :destroy, :id => "1"
      response.should redirect_to(lookup_consentforms_url)
    end
  end

end
