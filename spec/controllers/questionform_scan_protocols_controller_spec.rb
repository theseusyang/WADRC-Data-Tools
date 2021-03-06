require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe QuestionformScanProtocolsController do

  def mock_questionform_scan_protocol(stubs={})
    @mock_questionform_scan_protocol ||= mock_model(QuestionformScanProtocol, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all questionform_scan_protocols as @questionform_scan_protocols" do
      QuestionformScanProtocol.stub(:all) { [mock_questionform_scan_protocol] }
      get :index
      assigns(:questionform_scan_protocols).should eq([mock_questionform_scan_protocol])
    end
  end

  describe "GET show" do
    it "assigns the requested questionform_scan_protocol as @questionform_scan_protocol" do
      QuestionformScanProtocol.stub(:find).with("37") { mock_questionform_scan_protocol }
      get :show, :id => "37"
      assigns(:questionform_scan_protocol).should be(mock_questionform_scan_protocol)
    end
  end

  describe "GET new" do
    it "assigns a new questionform_scan_protocol as @questionform_scan_protocol" do
      QuestionformScanProtocol.stub(:new) { mock_questionform_scan_protocol }
      get :new
      assigns(:questionform_scan_protocol).should be(mock_questionform_scan_protocol)
    end
  end

  describe "GET edit" do
    it "assigns the requested questionform_scan_protocol as @questionform_scan_protocol" do
      QuestionformScanProtocol.stub(:find).with("37") { mock_questionform_scan_protocol }
      get :edit, :id => "37"
      assigns(:questionform_scan_protocol).should be(mock_questionform_scan_protocol)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created questionform_scan_protocol as @questionform_scan_protocol" do
        QuestionformScanProtocol.stub(:new).with({'these' => 'params'}) { mock_questionform_scan_protocol(:save => true) }
        post :create, :questionform_scan_protocol => {'these' => 'params'}
        assigns(:questionform_scan_protocol).should be(mock_questionform_scan_protocol)
      end

      it "redirects to the created questionform_scan_protocol" do
        QuestionformScanProtocol.stub(:new) { mock_questionform_scan_protocol(:save => true) }
        post :create, :questionform_scan_protocol => {}
        response.should redirect_to(questionform_scan_protocol_url(mock_questionform_scan_protocol))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved questionform_scan_protocol as @questionform_scan_protocol" do
        QuestionformScanProtocol.stub(:new).with({'these' => 'params'}) { mock_questionform_scan_protocol(:save => false) }
        post :create, :questionform_scan_protocol => {'these' => 'params'}
        assigns(:questionform_scan_protocol).should be(mock_questionform_scan_protocol)
      end

      it "re-renders the 'new' template" do
        QuestionformScanProtocol.stub(:new) { mock_questionform_scan_protocol(:save => false) }
        post :create, :questionform_scan_protocol => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested questionform_scan_protocol" do
        QuestionformScanProtocol.stub(:find).with("37") { mock_questionform_scan_protocol }
        mock_questionform_scan_protocol.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :questionform_scan_protocol => {'these' => 'params'}
      end

      it "assigns the requested questionform_scan_protocol as @questionform_scan_protocol" do
        QuestionformScanProtocol.stub(:find) { mock_questionform_scan_protocol(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:questionform_scan_protocol).should be(mock_questionform_scan_protocol)
      end

      it "redirects to the questionform_scan_protocol" do
        QuestionformScanProtocol.stub(:find) { mock_questionform_scan_protocol(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(questionform_scan_protocol_url(mock_questionform_scan_protocol))
      end
    end

    describe "with invalid params" do
      it "assigns the questionform_scan_protocol as @questionform_scan_protocol" do
        QuestionformScanProtocol.stub(:find) { mock_questionform_scan_protocol(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:questionform_scan_protocol).should be(mock_questionform_scan_protocol)
      end

      it "re-renders the 'edit' template" do
        QuestionformScanProtocol.stub(:find) { mock_questionform_scan_protocol(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested questionform_scan_protocol" do
      QuestionformScanProtocol.stub(:find).with("37") { mock_questionform_scan_protocol }
      mock_questionform_scan_protocol.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the questionform_scan_protocols list" do
      QuestionformScanProtocol.stub(:find) { mock_questionform_scan_protocol }
      delete :destroy, :id => "1"
      response.should redirect_to(questionform_scan_protocols_url)
    end
  end

end
