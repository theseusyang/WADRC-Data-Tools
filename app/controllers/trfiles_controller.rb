class TrfilesController < ApplicationController

  def trfile_edit_action
    scan_procedure_array =  (current_user.edit_low_scan_procedure_array).split(' ').map(&:to_i)
    # get params -- tredit_id ==> trfile_id, trype_id 
    if !params[:tredit_id].nil?
        @tredit = Tredit.find(params[:tredit_id])
        @trfiles = Trfile.where("trfiles.scan_procedure_id in (?)",scan_procedure_array).where("trfiles.id in (?)",@tredit.trfile_id)
       @trfile = @trfiles[0]
        @trfile.image_dataset_id  = params[:trfile_edit_action][:image_dataset_id]
        @trfile.file_completed_flag  = params[:trfile_edit_action][:file_completed_flag]
        @trfile.qc_value  = params[:trfile_edit_action][:qc_value]
        @trfile.status_flag  = params[:trfile_edit_action][:status_flag]
        @trfile.save
        @tredit.user_id = params[:tredit][:user_id]
        if !params[:value].nil?
             @tractiontypes = Tractiontype.where("trtype_id in (?)",@trfile.trtype_id).where("tractiontypes.form_display_order is not null")
             @tractiontypes.each do |ta|
               @tredit_actions = TreditAction.where("tredit_id in (?)",@tredit.id).where("tractiontype_id in (?)",ta.id)
              @tredit_action = @tredit_actions[0]
              v_value = nil
              if !params["value"][(ta.id).to_s].nil?
              v_value = params["value"][(ta.id).to_s].join(',')
               else
                  puts "bbbbbb nil = "+(ta.id).to_s
              end
              @tredit_action.value = v_value
              @tredit_action.save
              # trying to get the updated_at to propagate from the tredit_action to tredit/trfile 
              # not updating updated_at 
          #    if @tredit_action.updated_at > @trfile.updated_at or @tredit.updated_at > @trfile.updated_at
           #          @trfile_updated_at = @tredit_action.updated_at
            #         if @tredit.updated_at > @trfile.updated_at
             #           @trfile_updated_at = @tredit.updated_at
              #      end
               #     @trfile.save
             # end
             end
        end
    end
    # update trfile
    # update tredit
    # loop thru traction_edit
    # redirect back to trtype_home
    respond_to do |format|
          format.html { redirect_to( '/trtype_home/'+(@trfile.trtype_id).to_s, :notice => ' ' )}
    end

  end

  def trfile_home
    scan_procedure_array =  (current_user.view_low_scan_procedure_array).split(' ').map(&:to_i)
    scan_procedure_edit_array =  (current_user.edit_low_scan_procedure_array).split(' ').map(&:to_i)
  # make trfile if no trfile_id, also make tredit, and tredit_actions
  v_comment = ""
   @trfile = nil
   
      v_display_form = "Y"
   if !params[:trfile_action].nil? and params[:trfile_action] =="create"
     v_subjectid_v = params[:subjectid]

     v_trfile = Trfile.where("subjectid in (?)",v_subjectid_v).where("trtype_id in (?)",params[:id]).where("trfiles.scan_procedure_id in (?)",scan_procedure_edit_array)

     if !(v_trfile[0]).nil? 
        v_comment = v_comment + " There was already a file for "+v_subjectid_v+". This is the most recent edit."
        if !v_subjectid_v.include? "_v"
            v_comment = v_comment + " Did you mean to include _v2 or _v3 or _v# in the subjectid?"
        end
        @trfile = v_trfile[0]
        params[:trfile_action] = "get_edit"
        params[:trfile_id] = (@trfile.id).to_s
     else
       v_shared = Shared.new # using some functions in the Shared model --- this is the same as in schedule file upload
       v_sp_id = v_shared.get_sp_id_from_subjectid_v(v_subjectid_v)

        if v_sp_id.nil?
            v_comment = v_comment+" The subjectid "+v_subjectid_v+" was not mapped to a scan procedure. "
            v_display_form = "N"
        end
        v_enrollment_id = v_shared.get_enrollment_id_from_subjectid_v(v_subjectid_v)
        if v_enrollment_id.nil?
            v_comment = v_comment+" The subjectid "+v_subjectid_v+" was not mapped to an enrollment. " 
            v_display_form = "N"
        end
        if !v_sp_id.nil? and !v_enrollment_id.nil?
           @trfile = Trfile.new
           @trfile.subjectid = v_subjectid_v
           @trfile.enrollment_id = v_enrollment_id
           @trfile.scan_procedure_id = v_sp_id
           @trfile.trtype_id = params[:id]
           @trfile.save
        else
          v_display_form = "N"
        end 
      end
     # output v_comment
   end # end of create

   if !params[:trfile_action].nil? and ( params[:trfile_action] =="create" or ( params[:trfile_action] == "add_edit" and !params[:trfile_id].nil? ) )

         if params[:trfile_action] =="add_edit" 
             @trfiles = Trfile.where("trfiles.id in (?)",params[:trfile_id]).where("trfiles.scan_procedure_id in (?)",scan_procedure_edit_array)
             @trfile = @trfiles[0]
         end
         if !@trfile.nil?
            @tredit = Tredit.new
            @tredit.trfile_id = @trfile.id
            @tredit.user_id = current_user.id
            @tredit.save
            # make all the edit_actions for the tredit
            v_tractiontypes = Tractiontype.where("trtype_id in (?)",params[:id])
            if !v_tractiontypes.nil?
               v_tractiontypes.each do |tat|
                   v_tredit_action = TreditAction.new
                   v_tredit_action.tredit_id = @tredit.id
                   v_tredit_action.tractiontype_id = tat.id
                   v_tredit_action.save
               end
            end
         end
   end
   

  #  get most recent edit, edit_actions 
  if !params[:trfile_action].nil? and    params[:trfile_action] == "get_edit" and !params[:trfile_id].nil?  and !params[:tredit_id].nil?  

        @tredit = Tredit.find(params[:tredit_id])
        @trfile = Trfile.find(@tredit.trfile_id)
        if (@tredit.user_id).nil?
            @tredit.user_id = current_user.id
        end
  elsif !params[:trfile_action].nil? and    params[:trfile_action] == "get_edit" and !params[:trfile_id].nil?  and params[:tredit_id].nil?  

         @tredits = Tredit.where("trfile_id in (?)",params[:trfile_id]).order("created_at")
         @tredits.each do |te|
            @tredit = te # want the last one - newest created_at
         end
         @trfile = Trfile.find(@tredit.trfile_id)
        if (@tredit.user_id).nil?
            @tredit.user_id = current_user.id
        end

  end
  if v_display_form  == "N"
   # not get anything
  else
    @tredit_prev = nil
    @tredit_next = nil
    tredits = Tredit.where("tredits.trfile_id in (?)", @tredit.trfile_id).order(:id)
    @v_edit_cnt =1
    @v_last_edit = "N"
    v_cnt =0
    tredits.each do |tr|
      v_cnt = v_cnt + 1
      if tr.id < @tredit.id
         @tredit_prev = tr
      end
      if tr.id == @tredit.id
          @v_edit_cnt = v_cnt
      end
      if tr.id > @tredit.id and @tredit_next.nil?
         @tredit_next = tr
      end
    end
    if v_cnt == @v_edit_cnt 
         @v_last_edit = "Y"
    end
  

    # get all the scan procedures linked to vgroup

    @trfiles = Trfile.where("trfiles.scan_procedure_id in (?)",scan_procedure_array).where("trfiles.id in (?)",@trfile.id)
    @trfile = @trfiles[0]
    @trtype = Trtype.find(@trfile.trtype_id)
    @vgroups = Vgroup.where("vgroups.id in (select enrollment_vgroup_memberships.vgroup_id from enrollment_vgroup_memberships where enrollment_id in (?) )",@trfile.enrollment_id).where("vgroups.id in (select scan_procedures_vgroups.vgroup_id from scan_procedures_vgroups where scan_procedure_id in (?))",@trfile.scan_procedure_id)
       if !(@trfile.scan_procedure_id).nil? and !(@trfile.enrollment_id).nil? 
          @ids = ImageDataset.where(" image_datasets.visit_id in (select v1.id from visits v1, appointments a1, scan_procedures_vgroups spvg1, enrollment_vgroup_memberships evg1
                                                      where v1.appointment_id = a1.id and a1.vgroup_id =spvg1.vgroup_id and a1.vgroup_id = evg1.vgroup_id 
                                                      and spvg1.scan_procedure_id in (?) 
                                                      and evg1.enrollment_id in (?)) 
                                      and image_datasets.series_description in 
                                       ( select sdm1.series_description from series_description_maps sdm1 where series_description_type_id in (?))",
                    @trfile.scan_procedure_id ,@trfile.enrollment_id, @trtype.series_description_type_id)

      end
    end
  # get specified edit , edit_action in the form
    if !v_comment.blank?
     flash[:error] = v_comment
    end
    respond_to do |format|
      if v_display_form  == "N"
         format.html { redirect_to( '/trtype_home/'+params[:id], :notice => ' ' )}
      else
        format.html # index.html.erb
      end
      #format.json { render json: @trfiles }
    end
  end

  # GET /trfiles
  # GET /trfiles.json
  def index
    @trfiles = Trfile.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @trfiles }
    end
  end

  # GET /trfiles/1
  # GET /trfiles/1.json
  def show
    @trfile = Trfile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @trfile }
    end
  end

  # GET /trfiles/new
  # GET /trfiles/new.json
  def new
    @trfile = Trfile.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @trfile }
    end
  end

  # GET /trfiles/1/edit
  def edit
    @trfile = Trfile.find(params[:id])
    if !(@trfile.trtype_id).nil?
      @trtype = Trtype.find(@trfile.trtype_id)
      if !(@trfile.scan_procedure_id).nil? and !(@trfile.enrollment_id).nil? 
          @ids = ImageDataset.where(" image_datasets.visit_id in (select v1.id from visits v1, appointments a1, scan_procedures_vgroups spvg1, enrollment_vgroup_memberships evg1
                                                      where v1.appointment_id = a1.id and a1.vgroup_id =spvg1.vgroup_id and a1.vgroup_id = evg1.vgroup_id 
                                                      and spvg1.scan_procedure_id in (?) 
                                                      and evg1.enrollment_id in (?)) 
                                      and image_datasets.series_description in 
                                       ( select sdm1.series_description from series_description_maps sdm1 where series_description_type_id in (?))",
                    @trfile.scan_procedure_id ,@trfile.enrollment_id, @trtype.series_description_type_id)

      end
    end
  end

  # POST /trfiles
  # POST /trfiles.json
  def create
    @trfile = Trfile.new(params[:trfile])

    respond_to do |format|
      if @trfile.save
    if !(@trfile.subjectid).nil?
        v_shared = Shared.new # using some functions in the Shared model --- this is the same as in schedule file upload
        v_sp_id = v_shared.get_sp_id_from_subjectid_v(@trfile.subjectid)
        if !v_sp_id.nil?
            @trfile.scan_procedure_id = v_sp_id
        end
        v_enrollment_id = v_shared.get_enrollment_id_from_subjectid_v(@trfile.subjectid)
        @trfile.enrollment_id = v_enrollment_id

        @trfile.save
     end

        format.html { redirect_to @trfile, notice: 'Trfile was successfully created.' }
        format.json { render json: @trfile, status: :created, location: @trfile }
      else
        format.html { render action: "new" }
        format.json { render json: @trfile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /trfiles/1
  # PUT /trfiles/1.json
  def update
    @trfile = Trfile.find(params[:id])
    if !params[:trfile][:subjectid].nil?
        v_shared = Shared.new # using some functions in the Shared model --- this is the same as in schedule file upload
        v_sp_id = v_shared.get_sp_id_from_subjectid_v(params[:trfile][:subjectid])
        if !v_sp_id.nil?
            params[:trfile][:scan_procedure_id] = v_sp_id
        end
        v_enrollment_id = v_shared.get_enrollment_id_from_subjectid_v(params[:trfile][:subjectid])
        if !v_enrollment_id.nil?
            params[:trfile][:enrollment_id] = v_enrollment_id
        end
     end

    respond_to do |format|
      if @trfile.update_attributes(params[:trfile])
        format.html { redirect_to @trfile, notice: 'Trfile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @trfile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trfiles/1
  # DELETE /trfiles/1.json
  def destroy
    @trfile = Trfile.find(params[:id])
    @trfile.destroy

    respond_to do |format|
      format.html { redirect_to trfiles_url }
      format.json { head :no_content }
    end
  end
end
