require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe LookupConsentcohortsController do

  def mock_lookup_consentcohort(stubs={})
    @mock_lookup_consentcohort ||= mock_model(LookupConsentcohort, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all lookup_consentcohorts as @lookup_consentcohorts" do
      LookupConsentcohort.stub(:all) { [mock_lookup_consentcohort] }
      get :index
      assigns(:lookup_consentcohorts).should eq([mock_lookup_consentcohort])
    end
  end

  describe "GET show" do
    it "assigns the requested lookup_consentcohort as @lookup_consentcohort" do
      LookupConsentcohort.stub(:find).with("37") { mock_lookup_consentcohort }
      get :show, :id => "37"
      assigns(:lookup_consentcohort).should be(mock_lookup_consentcohort)
    end
  end

  describe "GET new" do
    it "assigns a new lookup_consentcohort as @lookup_consentcohort" do
      LookupConsentcohort.stub(:new) { mock_lookup_consentcohort }
      get :new
      assigns(:lookup_consentcohort).should be(mock_lookup_consentcohort)
    end
  end

  describe "GET edit" do
    it "assigns the requested lookup_consentcohort as @lookup_consentcohort" do
      LookupConsentcohort.stub(:find).with("37") { mock_lookup_consentcohort }
      get :edit, :id => "37"
      assigns(:lookup_consentcohort).should be(mock_lookup_consentcohort)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created lookup_consentcohort as @lookup_consentcohort" do
        LookupConsentcohort.stub(:new).with({'these' => 'params'}) { mock_lookup_consentcohort(:save => true) }
        post :create, :lookup_consentcohort => {'these' => 'params'}
        assigns(:lookup_consentcohort).should be(mock_lookup_consentcohort)
      end

      it "redirects to the created lookup_consentcohort" do
        LookupConsentcohort.stub(:new) { mock_lookup_consentcohort(:save => true) }
        post :create, :lookup_consentcohort => {}
        response.should redirect_to(lookup_consentcohort_url(mock_lookup_consentcohort))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved lookup_consentcohort as @lookup_consentcohort" do
        LookupConsentcohort.stub(:new).with({'these' => 'params'}) { mock_lookup_consentcohort(:save => false) }
        post :create, :lookup_consentcohort => {'these' => 'params'}
        assigns(:lookup_consentcohort).should be(mock_lookup_consentcohort)
      end

      it "re-renders the 'new' template" do
        LookupConsentcohort.stub(:new) { mock_lookup_consentcohort(:save => false) }
        post :create, :lookup_consentcohort => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested lookup_consentcohort" do
        LookupConsentcohort.stub(:find).with("37") { mock_lookup_consentcohort }
        mock_lookup_consentcohort.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :lookup_consentcohort => {'these' => 'params'}
      end

      it "assigns the requested lookup_consentcohort as @lookup_consentcohort" do
        LookupConsentcohort.stub(:find) { mock_lookup_consentcohort(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:lookup_consentcohort).should be(mock_lookup_consentcohort)
      end

      it "redirects to the lookup_consentcohort" do
        LookupConsentcohort.stub(:find) { mock_lookup_consentcohort(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(lookup_consentcohort_url(mock_lookup_consentcohort))
      end
    end

    describe "with invalid params" do
      it "assigns the lookup_consentcohort as @lookup_consentcohort" do
        LookupConsentcohort.stub(:find) { mock_lookup_consentcohort(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:lookup_consentcohort).should be(mock_lookup_consentcohort)
      end

      it "re-renders the 'edit' template" do
        LookupConsentcohort.stub(:find) { mock_lookup_consentcohort(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested lookup_consentcohort" do
      LookupConsentcohort.stub(:find).with("37") { mock_lookup_consentcohort }
      mock_lookup_consentcohort.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the lookup_consentcohorts list" do
      LookupConsentcohort.stub(:find) { mock_lookup_consentcohort }
      delete :destroy, :id => "1"
      response.should redirect_to(lookup_consentcohorts_url)
    end
  end

end
