class PetscansController < ApplicationController
  # GET /petscans
  # GET /petscans.xml
 
  def petscan_search
     @current_tab = "petscans"
     params["search_criteria"] =""

     if params[:petscan_search].nil?
          params[:petscan_search] =Hash.new  
     end
     
     scan_procedure_array = []
     scan_procedure_array =  (current_user.edit_low_scan_procedure_array).split(' ').map(&:to_i)   
     
#    @petscans = Petscan.where("petscans.appointment_id in (select appointments.id from appointments,scan_procedures_vgroups where 
#                                       appointments.vgroup_id = scan_procedures_vgroups.vgroup_id 
#    and scan_procedure_id in (?))", scan_procedure_array).all
#     sql = "select * from petscans inner join  appointments on appointments.id = petscans.appointment_id order by appointment_date desc"
#      @search = Petscan.find_by_sql(sql)
#     @search = Petscan.where("petscans.appointment_id in (select appointments.id from appointments)").all
      @search = Petscan.search(params[:search])    # parms search makes something which works with where?

      if !params[:petscan_search][:scan_procedure_id].blank?
         @search =@search.where("petscans.appointment_id in (select appointments.id from appointments,scan_procedures_vgroups where 
                                                appointments.vgroup_id = scan_procedures_vgroups.vgroup_id 
                                                and scan_procedure_id in (?))",params[:petscan_search][:scan_procedure_id])
         @scan_procedures = ScanProcedure.where("id in (?)",params[:petscan_search][:scan_procedure_id])
         params["search_criteria"] = params["search_criteria"] +", "+@scan_procedures.sort_by(&:codename).collect {|sp| sp.codename}.join(", ").html_safe
      end
      
      if !params[:petscan_search][:ecatfilename].blank?
         var = "%"+params[:petscan_search][:ecatfilename].downcase+"%"
         @search =@search.where(" petscans.ecatfilename  like ? ", var)
          params["search_criteria"] = params["search_criteria"] +", Series description "+params[:petscan_search][:ecatfilename]
      end
      
      if !params[:petscan_search][:enumber].blank?
         @search =@search.where(" petscans.appointment_id in (select appointments.id from enrollment_vgroup_memberships,enrollments, appointments
          where enrollment_vgroup_memberships.vgroup_id= appointments.vgroup_id 
          and enrollment_vgroup_memberships.enrollment_id = enrollments.id and lower(enrollments.enumber) in (lower(?)))",params[:petscan_search][:enumber])
          params["search_criteria"] = params["search_criteria"] +",  enumber "+params[:petscan_search][:enumber]
      end      

      if !params[:petscan_search][:rmr].blank? 
          @search = @search.where(" petscans.appointment_id in (select appointments.id from appointments,vgroups
                    where appointments.vgroup_id = vgroups.id and  lower(vgroups.rmr) in (lower(?)   ))",params[:petscan_search][:rmr])
          params["search_criteria"] = params["search_criteria"] +",  RMR "+params[:petscan_search][:rmr]
      end

       #  build expected date format --- between, >, < 
       v_date_latest =""
       #want all three date parts
      
       if !params[:petscan_search]["#{'latest_timestamp'}(1i)"].blank? && !params[:petscan_search]["#{'latest_timestamp'}(2i)"].blank? && !params[:petscan_search]["#{'latest_timestamp'}(3i)"].blank?
            v_date_latest = params[:petscan_search]["#{'latest_timestamp'}(1i)"] +"-"+params[:petscan_search]["#{'latest_timestamp'}(2i)"].rjust(2,"0")+"-"+params[:petscan_search]["#{'latest_timestamp'}(3i)"].rjust(2,"0")
       end

       v_date_earliest =""
       #want all three date parts
  
       if !params[:petscan_search]["#{'earliest_timestamp'}(1i)"].blank? && !params[:petscan_search]["#{'earliest_timestamp'}(2i)"].blank? && !params[:petscan_search]["#{'earliest_timestamp'}(3i)"].blank?
             v_date_earliest = params[:petscan_search]["#{'earliest_timestamp'}(1i)"] +"-"+params[:petscan_search]["#{'earliest_timestamp'}(2i)"].rjust(2,"0")+"-"+params[:petscan_search]["#{'earliest_timestamp'}(3i)"].rjust(2,"0")
        end

       if v_date_latest.length>0 && v_date_earliest.length >0
         @search = @search.where(" petscans.appointment_id in (select appointments.id from appointments where appointments.appointment_date between ? and ? )",v_date_earliest,v_date_latest)
         params["search_criteria"] = params["search_criteria"] +",  visit date between "+v_date_earliest+" and "+v_date_latest
       elsif v_date_latest.length>0
         @search = @search.where(" petscans.appointment_id in (select appointments.id from appointments where appointments.appointment_date < ?  )",v_date_latest)
          params["search_criteria"] = params["search_criteria"] +",  visit date before "+v_date_latest 
       elsif  v_date_earliest.length >0
         @search = @search.where(" petscans.appointment_id in (select appointments.id from appointments where appointments.appointment_date > ? )",v_date_earliest)
          params["search_criteria"] = params["search_criteria"] +",  visit date after "+v_date_earliest
        end

        if !params[:petscan_search][:gender].blank?
           @search =@search.where(" petscans.appointment_id in (select appointments.id from participants,  enrollment_vgroup_memberships, enrollments,appointments
            where enrollment_vgroup_memberships.enrollment_id = enrollments.id and enrollments.participant_id = participants.id 
            and enrollment_vgroup_memberships.vgroup_id = appointments.vgroup_id
                   and participants.gender is not NULL and participants.gender in (?) )", params[:petscan_search][:gender])
            if params[:petscan_search][:gender] == 1
               params["search_criteria"] = params["search_criteria"] +",  sex is Male"
            elsif params[:petscan_search][:gender] == 2
               params["search_criteria"] = params["search_criteria"] +",  sex is Female"
            end
        end   

        if !params[:petscan_search][:min_age].blank? && params[:petscan_search][:max_age].blank?
            @search = @search.where("  petscans.appointment_id in (select appointments.id from participants,  enrollment_vgroup_memberships, enrollments, scan_procedures_vgroups,appointments
                               where enrollment_vgroup_memberships.enrollment_id = enrollments.id and enrollments.participant_id = participants.id
                            and  scan_procedures_vgroups.vgroup_id = enrollment_vgroup_memberships.vgroup_id 
                            and appointments.vgroup_id = enrollment_vgroup_memberships.vgroup_id
                            and floor(DATEDIFF(appointments.appointment_date,participants.dob)/365.25) >= ?   )",params[:petscan_search][:min_age])
            params["search_criteria"] = params["search_criteria"] +",  age at visit >= "+params[:petscan_search][:min_age]
        elsif params[:petscan_search][:min_age].blank? && !params[:petscan_search][:max_age].blank?
             @search = @search.where("  petscans.appointment_id in (select appointments.id from participants,  enrollment_vgroup_memberships, enrollments, scan_procedures_vgroups,appointments
                                where enrollment_vgroup_memberships.enrollment_id = enrollments.id and enrollments.participant_id = participants.id
                             and  scan_procedures_vgroups.vgroup_id = enrollment_vgroup_memberships.vgroup_id 
                             and appointments.vgroup_id = enrollment_vgroup_memberships.vgroup_id
                         and floor(DATEDIFF(appointments.appointment_date,participants.dob)/365.25) <= ?   )",params[:petscan_search][:max_age])
            params["search_criteria"] = params["search_criteria"] +",  age at visit <= "+params[:petscan_search][:max_age]
        elsif !params[:petscan_search][:min_age].blank? && !params[:petscan_search][:max_age].blank?
           @search = @search.where("   petscans.appointment_id in (select appointments.id from participants,  enrollment_vgroup_memberships, enrollments, scan_procedures_vgroups,appointments
                              where enrollment_vgroup_memberships.enrollment_id = enrollments.id and enrollments.participant_id = participants.id
                           and  scan_procedures_vgroups.vgroup_id = enrollment_vgroup_memberships.vgroup_id 
                           and appointments.vgroup_id = enrollment_vgroup_memberships.vgroup_id
                       and floor(DATEDIFF(appointments.appointment_date,participants.dob)/365.25) between ? and ?   )",params[:petscan_search][:min_age],params[:petscan_search][:max_age])
          params["search_criteria"] = params["search_criteria"] +",  age at visit between "+params[:petscan_search][:min_age]+" and "+params[:petscan_search][:max_age]
        end
        # trim leading ","
        params["search_criteria"] = params["search_criteria"].sub(", ","")
        # pass to download file?
        
    @search =  @search.where("petscans.appointment_id in (select appointments.id from appointments,scan_procedures_vgroups where 
                                               appointments.vgroup_id = scan_procedures_vgroups.vgroup_id 
                                               and scan_procedure_id in (?))", scan_procedure_array)


    @petscans = @search
    @petscans =  @search.page(params[:page])
    ### LOOK WHERE TITLE IS SHOWING UP
    @collection_title = 'All Petscan appts'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @petscans }
    end
  end

  # GET /petscans/1
  # GET /petscans/1.xml
  def show
    @current_tab = "petscans"
    scan_procedure_array = []
    scan_procedure_array =  (current_user.edit_low_scan_procedure_array).split(' ').map(&:to_i)
     
    @petscan = Petscan.where("petscans.appointment_id in (select appointments.id from appointments,scan_procedures_vgroups where 
                                      appointments.vgroup_id = scan_procedures_vgroups.vgroup_id 
                                      and scan_procedure_id in (?))", scan_procedure_array).find(params[:id])

    @appointment = Appointment.find(@petscan.appointment_id)                            

    @petscans = Petscan.where("petscans.appointment_id in (select appointments.id from appointments,scan_procedures_vgroups where 
                                appointments.vgroup_id = scan_procedures_vgroups.vgroup_id 
                               and appointments.appointment_date between ? and ?
                               and scan_procedure_id in (?))", @appointment.appointment_date-2.month,@appointment.appointment_date+2,scan_procedure_array).all

    idx = @petscans.index(@petscan)
    @older_petscan = idx + 1 >= @petscans.size ? nil : @petscans[idx + 1]
    @newer_petscan = idx - 1 < 0 ? nil : @petscans[idx - 1]
    
    @vgroup = Vgroup.find(@appointment.vgroup_id)
    @participant = @vgroup.try(:participant)
    @enumbers = @vgroup.enrollments

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @petscan }
    end
  end

  # GET /petscans/new
  # GET /petscans/new.xml
  def new
    @petscan = Petscan.new
    vgroup_id = params[:id]
    @appointment = Appointment.new
    @appointment.vgroup_id = vgroup_id
    @appointment.appointment_date = (Vgroup.find(vgroup_id)).vgroup_date
    @appointment.appointment_type ='pet_scan'
    @appointment.save
    @petscan.appointment_id = @appointment.id
    params[:new_appointment_id] = @appointment.id  
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @petscan }
    end
  end

  # GET /petscans/1/edit
  def edit
     @current_tab = "petscans"
     scan_procedure_array = []
     scan_procedure_array =  (current_user.edit_low_scan_procedure_array).split(' ').map(&:to_i)
     @petscan = Petscan.where("petscans.appointment_id in (select appointments.id from appointments,scan_procedures_vgroups where 
                                       appointments.vgroup_id = scan_procedures_vgroups.vgroup_id 
                                       and scan_procedure_id in (?))", scan_procedure_array).find(params[:id])
     @appointment = Appointment.find(@petscan.appointment_id) 
  end

  # POST /petscans
  # POST /petscans.xml
  def create
     @current_tab = "petscans"
    @petscan = Petscan.new(params[:petscan])
    @petscan.appointment_id = params[:new_appointment_id]
    
    params[:date][:injectiont][0]="1899"
    params[:date][:injectiont][1]="12"
    params[:date][:injectiont][2]="30"
    injectiontime = nil
    if !params[:date][:injectiont][0].blank? && !params[:date][:injectiont][1].blank? && !params[:date][:injectiont][2].blank? && !params[:date][:injectiont][3].blank? && !params[:date][:injectiont][4].blank?
      injectiontime =  params[:date][:injectiont][0]+"-"+params[:date][:injectiont][1]+"-"+params[:date][:injectiont][2]+" "+params[:date][:injectiont][3]+":"+params[:date][:injectiont][4]
     @petscan.injecttiontime = injectiontime
    end

    params[:date][:scanstartt][0]="1899"
    params[:date][:scanstartt][1]="12"
    params[:date][:scanstartt][2]="30"       
    scanstarttime = nil
    if !params[:date][:scanstartt][0].blank? && !params[:date][:scanstartt][1].blank? && !params[:date][:scanstartt][2].blank? && !params[:date][:scanstartt][3].blank? && !params[:date][:scanstartt][4].blank?
      scanstarttime =  params[:date][:scanstartt][0]+"-"+params[:date][:scanstartt][1]+"-"+params[:date][:scanstartt][2]+" "+params[:date][:scanstartt][3]+":"+params[:date][:scanstartt][4]
      @petscan.scanstarttime = scanstarttime
    end  

    @appointment = Appointment.find(@petscan.appointment_id)
    @appointment.comment = params[:appointment][:comment]
    appointment_date = nil
    if !params[:appointment]["#{'appointment_date'}(1i)"].blank? && !params[:appointment]["#{'appointment_date'}(2i)"].blank? && !params[:appointment]["#{'appointment_date'}(3i)"].blank?
         appointment_date = params[:appointment]["#{'appointment_date'}(1i)"] +"-"+params[:appointment]["#{'appointment_date'}(2i)"].rjust(2,"0")+"-"+params[:appointment]["#{'appointment_date'}(3i)"].rjust(2,"0")
    end
    @appointment.appointment_date =appointment_date
    @appointment.save
    respond_to do |format|
      if @petscan.save
        if !params[:vital_id].blank?
          @vital = Vital.find(params[:vital_id])
          @vital.pulse = params[:pulse]
          @vital.bp_systol = params[:bp_systol]
          @vital.bp_diastol = params[:bp_diastol]
          @vital.bloodglucose = params[:bloodglucose]
          @vital.save
        else
          @vital = Vital.new
          @vital.appointment_id = @petscan.appointment_id
          @vital.pulse = params[:pulse]
          @vital.bp_systol = params[:bp_systol]
          @vital.bp_diastol = params[:bp_diastol]
          @vital.bloodglucose = params[:bloodglucose]
          @vital.save      
        end        
        format.html { redirect_to(@petscan, :notice => 'Petscan was successfully created.') }
        format.xml  { render :xml => @petscan, :status => :created, :location => @petscan }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @petscan.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /petscans/1
  # PUT /petscans/1.xml
  def update
    
    scan_procedure_array = []
    scan_procedure_array =  (current_user.edit_low_scan_procedure_array).split(' ').map(&:to_i)
     
    @petscan = Petscan.where("petscans.appointment_id in (select appointments.id from appointments,scan_procedures_vgroups where 
                                      appointments.vgroup_id = scan_procedures_vgroups.vgroup_id 
                                      and scan_procedure_id in (?))", scan_procedure_array).find(params[:id])
                                      
    appointment_date = nil
    if !params[:appointment]["#{'appointment_date'}(1i)"].blank? && !params[:appointment]["#{'appointment_date'}(2i)"].blank? && !params[:appointment]["#{'appointment_date'}(3i)"].blank?
         appointment_date = params[:appointment]["#{'appointment_date'}(1i)"] +"-"+params[:appointment]["#{'appointment_date'}(2i)"].rjust(2,"0")+"-"+params[:appointment]["#{'appointment_date'}(3i)"].rjust(2,"0")
    end
      params[:date][:injectiont][0]="1899"
      params[:date][:injectiont][1]="12"
      params[:date][:injectiont][2]="30"
      injectiontime = nil
      if !params[:date][:injectiont][0].blank? && !params[:date][:injectiont][1].blank? && !params[:date][:injectiont][2].blank? && !params[:date][:injectiont][3].blank? && !params[:date][:injectiont][4].blank?
injectiontime =  params[:date][:injectiont][0]+"-"+params[:date][:injectiont][1]+"-"+params[:date][:injectiont][2]+" "+params[:date][:injectiont][3]+":"+params[:date][:injectiont][4]
      params[:petscan][:injecttiontime] = injectiontime
       end

       params[:date][:scanstartt][0]="1899"
       params[:date][:scanstartt][1]="12"
       params[:date][:scanstartt][2]="30"       
        scanstarttime = nil
      if !params[:date][:scanstartt][0].blank? && !params[:date][:scanstartt][1].blank? && !params[:date][:scanstartt][2].blank? && !params[:date][:scanstartt][3].blank? && !params[:date][:scanstartt][4].blank?
  scanstarttime =  params[:date][:scanstartt][0]+"-"+params[:date][:scanstartt][1]+"-"+params[:date][:scanstartt][2]+" "+params[:date][:scanstartt][3]+":"+params[:date][:scanstartt][4]
       params[:petscan][:scanstarttime] = scanstarttime
      end

    # ok to update vitals even if other update fail
    if !params[:vital_id].blank?
      @vital = Vital.find(params[:vital_id])
      @vital.pulse = params[:pulse]
      @vital.bp_systol = params[:bp_systol]
      @vital.bp_diastol = params[:bp_diastol]
      @vital.bloodglucose = params[:bloodglucose]
      @vital.save
    else
      @vital = Vital.new
      @vital.appointment_id = @petscan.appointment_id
      @vital.pulse = params[:pulse]
      @vital.bp_systol = params[:bp_systol]
      @vital.bp_diastol = params[:bp_diastol]
      @vital.bloodglucose = params[:bloodglucose]
      @vital.save      
    end
puts "BBBBBBBBBBBBBBBBB"
    respond_to do |format|
      if @petscan.update_attributes(params[:petscan])
        @appointment = Appointment.find(@petscan.appointment_id)
        @appointment.comment = params[:appointment][:comment]
        @appointment.appointment_date =appointment_date
        @appointment.save
        format.html { redirect_to(@petscan, :notice => 'Petscan was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @petscan.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /petscans/1
  # DELETE /petscans/1.xml
  def destroy
    scan_procedure_array = []
    scan_procedure_array =  (current_user.edit_low_scan_procedure_array).split(' ').map(&:to_i)
     
    @petscan = Petscan.where("petscans.appointment_id in (select appointments.id from appointments,scan_procedures_vgroups where 
                                      appointments.vgroup_id = scan_procedures_vgroups.vgroup_id 
                                      and scan_procedure_id in (?))", scan_procedure_array).find(params[:id])
    @petscan.destroy

    respond_to do |format|
      format.html { redirect_to(petscans_url) }
      format.xml  { head :ok }
    end
  end
end
