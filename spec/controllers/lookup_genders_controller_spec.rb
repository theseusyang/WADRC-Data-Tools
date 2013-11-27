require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe LookupGendersController do

  def mock_lookup_gender(stubs={})
    @mock_lookup_gender ||= mock_model(LookupGender, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all lookup_genders as @lookup_genders" do
      LookupGender.stub(:all) { [mock_lookup_gender] }
      get :index
      assigns(:lookup_genders).should eq([mock_lookup_gender])
    end
  end

  describe "GET show" do
    it "assigns the requested lookup_gender as @lookup_gender" do
      LookupGender.stub(:find).with("37") { mock_lookup_gender }
      get :show, :id => "37"
      assigns(:lookup_gender).should be(mock_lookup_gender)
    end
  end

  describe "GET new" do
    it "assigns a new lookup_gender as @lookup_gender" do
      LookupGender.stub(:new) { mock_lookup_gender }
      get :new
      assigns(:lookup_gender).should be(mock_lookup_gender)
    end
  end

  describe "GET edit" do
    it "assigns the requested lookup_gender as @lookup_gender" do
      LookupGender.stub(:find).with("37") { mock_lookup_gender }
      get :edit, :id => "37"
      assigns(:lookup_gender).should be(mock_lookup_gender)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created lookup_gender as @lookup_gender" do
        LookupGender.stub(:new).with({'these' => 'params'}) { mock_lookup_gender(:save => true) }
        post :create, :lookup_gender => {'these' => 'params'}
        assigns(:lookup_gender).should be(mock_lookup_gender)
      end

      it "redirects to the created lookup_gender" do
        LookupGender.stub(:new) { mock_lookup_gender(:save => true) }
        post :create, :lookup_gender => {}
        response.should redirect_to(lookup_gender_url(mock_lookup_gender))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved lookup_gender as @lookup_gender" do
        LookupGender.stub(:new).with({'these' => 'params'}) { mock_lookup_gender(:save => false) }
        post :create, :lookup_gender => {'these' => 'params'}
        assigns(:lookup_gender).should be(mock_lookup_gender)
      end

      it "re-renders the 'new' template" do
        LookupGender.stub(:new) { mock_lookup_gender(:save => false) }
        post :create, :lookup_gender => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested lookup_gender" do
        LookupGender.stub(:find).with("37") { mock_lookup_gender }
        mock_lookup_gender.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :lookup_gender => {'these' => 'params'}
      end

      it "assigns the requested lookup_gender as @lookup_gender" do
        LookupGender.stub(:find) { mock_lookup_gender(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:lookup_gender).should be(mock_lookup_gender)
      end

      it "redirects to the lookup_gender" do
        LookupGender.stub(:find) { mock_lookup_gender(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(lookup_gender_url(mock_lookup_gender))
      end
    end

    describe "with invalid params" do
      it "assigns the lookup_gender as @lookup_gender" do
        LookupGender.stub(:find) { mock_lookup_gender(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:lookup_gender).should be(mock_lookup_gender)
      end

      it "re-renders the 'edit' template" do
        LookupGender.stub(:find) { mock_lookup_gender(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested lookup_gender" do
      LookupGender.stub(:find).with("37") { mock_lookup_gender }
      mock_lookup_gender.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the lookup_genders list" do
      LookupGender.stub(:find) { mock_lookup_gender }
      delete :destroy, :id => "1"
      response.should redirect_to(lookup_genders_url)
    end
  end

end
