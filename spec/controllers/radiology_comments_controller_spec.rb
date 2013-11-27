require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe RadiologyCommentsController do

  def mock_radiology_comment(stubs={})
    @mock_radiology_comment ||= mock_model(RadiologyComment, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all radiology_comments as @radiology_comments" do
      RadiologyComment.stub(:all) { [mock_radiology_comment] }
      get :index
      assigns(:radiology_comments).should eq([mock_radiology_comment])
    end
  end

  describe "GET show" do
    it "assigns the requested radiology_comment as @radiology_comment" do
      RadiologyComment.stub(:find).with("37") { mock_radiology_comment }
      get :show, :id => "37"
      assigns(:radiology_comment).should be(mock_radiology_comment)
    end
  end

  describe "GET new" do
    it "assigns a new radiology_comment as @radiology_comment" do
      RadiologyComment.stub(:new) { mock_radiology_comment }
      get :new
      assigns(:radiology_comment).should be(mock_radiology_comment)
    end
  end

  describe "GET edit" do
    it "assigns the requested radiology_comment as @radiology_comment" do
      RadiologyComment.stub(:find).with("37") { mock_radiology_comment }
      get :edit, :id => "37"
      assigns(:radiology_comment).should be(mock_radiology_comment)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created radiology_comment as @radiology_comment" do
        RadiologyComment.stub(:new).with({'these' => 'params'}) { mock_radiology_comment(:save => true) }
        post :create, :radiology_comment => {'these' => 'params'}
        assigns(:radiology_comment).should be(mock_radiology_comment)
      end

      it "redirects to the created radiology_comment" do
        RadiologyComment.stub(:new) { mock_radiology_comment(:save => true) }
        post :create, :radiology_comment => {}
        response.should redirect_to(radiology_comment_url(mock_radiology_comment))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved radiology_comment as @radiology_comment" do
        RadiologyComment.stub(:new).with({'these' => 'params'}) { mock_radiology_comment(:save => false) }
        post :create, :radiology_comment => {'these' => 'params'}
        assigns(:radiology_comment).should be(mock_radiology_comment)
      end

      it "re-renders the 'new' template" do
        RadiologyComment.stub(:new) { mock_radiology_comment(:save => false) }
        post :create, :radiology_comment => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested radiology_comment" do
        RadiologyComment.stub(:find).with("37") { mock_radiology_comment }
        mock_radiology_comment.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :radiology_comment => {'these' => 'params'}
      end

      it "assigns the requested radiology_comment as @radiology_comment" do
        RadiologyComment.stub(:find) { mock_radiology_comment(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:radiology_comment).should be(mock_radiology_comment)
      end

      it "redirects to the radiology_comment" do
        RadiologyComment.stub(:find) { mock_radiology_comment(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(radiology_comment_url(mock_radiology_comment))
      end
    end

    describe "with invalid params" do
      it "assigns the radiology_comment as @radiology_comment" do
        RadiologyComment.stub(:find) { mock_radiology_comment(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:radiology_comment).should be(mock_radiology_comment)
      end

      it "re-renders the 'edit' template" do
        RadiologyComment.stub(:find) { mock_radiology_comment(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested radiology_comment" do
      RadiologyComment.stub(:find).with("37") { mock_radiology_comment }
      mock_radiology_comment.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the radiology_comments list" do
      RadiologyComment.stub(:find) { mock_radiology_comment }
      delete :destroy, :id => "1"
      response.should redirect_to(radiology_comments_url)
    end
  end

end
