require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe CgQueriesController do

  def mock_cg_query(stubs={})
    @mock_cg_query ||= mock_model(CgQuery, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all cg_queries as @cg_queries" do
      CgQuery.stub(:all) { [mock_cg_query] }
      get :index
      assigns(:cg_queries).should eq([mock_cg_query])
    end
  end

  describe "GET show" do
    it "assigns the requested cg_query as @cg_query" do
      CgQuery.stub(:find).with("37") { mock_cg_query }
      get :show, :id => "37"
      assigns(:cg_query).should be(mock_cg_query)
    end
  end

  describe "GET new" do
    it "assigns a new cg_query as @cg_query" do
      CgQuery.stub(:new) { mock_cg_query }
      get :new
      assigns(:cg_query).should be(mock_cg_query)
    end
  end

  describe "GET edit" do
    it "assigns the requested cg_query as @cg_query" do
      CgQuery.stub(:find).with("37") { mock_cg_query }
      get :edit, :id => "37"
      assigns(:cg_query).should be(mock_cg_query)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created cg_query as @cg_query" do
        CgQuery.stub(:new).with({'these' => 'params'}) { mock_cg_query(:save => true) }
        post :create, :cg_query => {'these' => 'params'}
        assigns(:cg_query).should be(mock_cg_query)
      end

      it "redirects to the created cg_query" do
        CgQuery.stub(:new) { mock_cg_query(:save => true) }
        post :create, :cg_query => {}
        response.should redirect_to(cg_query_url(mock_cg_query))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved cg_query as @cg_query" do
        CgQuery.stub(:new).with({'these' => 'params'}) { mock_cg_query(:save => false) }
        post :create, :cg_query => {'these' => 'params'}
        assigns(:cg_query).should be(mock_cg_query)
      end

      it "re-renders the 'new' template" do
        CgQuery.stub(:new) { mock_cg_query(:save => false) }
        post :create, :cg_query => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested cg_query" do
        CgQuery.stub(:find).with("37") { mock_cg_query }
        mock_cg_query.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :cg_query => {'these' => 'params'}
      end

      it "assigns the requested cg_query as @cg_query" do
        CgQuery.stub(:find) { mock_cg_query(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:cg_query).should be(mock_cg_query)
      end

      it "redirects to the cg_query" do
        CgQuery.stub(:find) { mock_cg_query(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(cg_query_url(mock_cg_query))
      end
    end

    describe "with invalid params" do
      it "assigns the cg_query as @cg_query" do
        CgQuery.stub(:find) { mock_cg_query(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:cg_query).should be(mock_cg_query)
      end

      it "re-renders the 'edit' template" do
        CgQuery.stub(:find) { mock_cg_query(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested cg_query" do
      CgQuery.stub(:find).with("37") { mock_cg_query }
      mock_cg_query.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the cg_queries list" do
      CgQuery.stub(:find) { mock_cg_query }
      delete :destroy, :id => "1"
      response.should redirect_to(cg_queries_url)
    end
  end

end
