require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe LookupDemographicincomesController do

  def mock_lookup_demographicincome(stubs={})
    @mock_lookup_demographicincome ||= mock_model(LookupDemographicincome, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all lookup_demographicincomes as @lookup_demographicincomes" do
      LookupDemographicincome.stub(:all) { [mock_lookup_demographicincome] }
      get :index
      assigns(:lookup_demographicincomes).should eq([mock_lookup_demographicincome])
    end
  end

  describe "GET show" do
    it "assigns the requested lookup_demographicincome as @lookup_demographicincome" do
      LookupDemographicincome.stub(:find).with("37") { mock_lookup_demographicincome }
      get :show, :id => "37"
      assigns(:lookup_demographicincome).should be(mock_lookup_demographicincome)
    end
  end

  describe "GET new" do
    it "assigns a new lookup_demographicincome as @lookup_demographicincome" do
      LookupDemographicincome.stub(:new) { mock_lookup_demographicincome }
      get :new
      assigns(:lookup_demographicincome).should be(mock_lookup_demographicincome)
    end
  end

  describe "GET edit" do
    it "assigns the requested lookup_demographicincome as @lookup_demographicincome" do
      LookupDemographicincome.stub(:find).with("37") { mock_lookup_demographicincome }
      get :edit, :id => "37"
      assigns(:lookup_demographicincome).should be(mock_lookup_demographicincome)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created lookup_demographicincome as @lookup_demographicincome" do
        LookupDemographicincome.stub(:new).with({'these' => 'params'}) { mock_lookup_demographicincome(:save => true) }
        post :create, :lookup_demographicincome => {'these' => 'params'}
        assigns(:lookup_demographicincome).should be(mock_lookup_demographicincome)
      end

      it "redirects to the created lookup_demographicincome" do
        LookupDemographicincome.stub(:new) { mock_lookup_demographicincome(:save => true) }
        post :create, :lookup_demographicincome => {}
        response.should redirect_to(lookup_demographicincome_url(mock_lookup_demographicincome))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved lookup_demographicincome as @lookup_demographicincome" do
        LookupDemographicincome.stub(:new).with({'these' => 'params'}) { mock_lookup_demographicincome(:save => false) }
        post :create, :lookup_demographicincome => {'these' => 'params'}
        assigns(:lookup_demographicincome).should be(mock_lookup_demographicincome)
      end

      it "re-renders the 'new' template" do
        LookupDemographicincome.stub(:new) { mock_lookup_demographicincome(:save => false) }
        post :create, :lookup_demographicincome => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested lookup_demographicincome" do
        LookupDemographicincome.stub(:find).with("37") { mock_lookup_demographicincome }
        mock_lookup_demographicincome.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :lookup_demographicincome => {'these' => 'params'}
      end

      it "assigns the requested lookup_demographicincome as @lookup_demographicincome" do
        LookupDemographicincome.stub(:find) { mock_lookup_demographicincome(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:lookup_demographicincome).should be(mock_lookup_demographicincome)
      end

      it "redirects to the lookup_demographicincome" do
        LookupDemographicincome.stub(:find) { mock_lookup_demographicincome(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(lookup_demographicincome_url(mock_lookup_demographicincome))
      end
    end

    describe "with invalid params" do
      it "assigns the lookup_demographicincome as @lookup_demographicincome" do
        LookupDemographicincome.stub(:find) { mock_lookup_demographicincome(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:lookup_demographicincome).should be(mock_lookup_demographicincome)
      end

      it "re-renders the 'edit' template" do
        LookupDemographicincome.stub(:find) { mock_lookup_demographicincome(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested lookup_demographicincome" do
      LookupDemographicincome.stub(:find).with("37") { mock_lookup_demographicincome }
      mock_lookup_demographicincome.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the lookup_demographicincomes list" do
      LookupDemographicincome.stub(:find) { mock_lookup_demographicincome }
      delete :destroy, :id => "1"
      response.should redirect_to(lookup_demographicincomes_url)
    end
  end

end
