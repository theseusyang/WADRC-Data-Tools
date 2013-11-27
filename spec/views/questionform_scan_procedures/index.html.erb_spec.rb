require 'spec_helper'

describe "questionform_scan_procedures/index.html.erb" do
  before(:each) do
    assign(:questionform_scan_procedures, [
      stub_model(QuestionformScanProcedure,
        :questionform_id => 1,
        :scan_procedure_id => 1,
        :include_exclude => "Include Exclude"
      ),
      stub_model(QuestionformScanProcedure,
        :questionform_id => 1,
        :scan_procedure_id => 1,
        :include_exclude => "Include Exclude"
      )
    ])
  end

  it "renders a list of questionform_scan_procedures" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Include Exclude".to_s, :count => 2
  end
end
