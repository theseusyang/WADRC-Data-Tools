# encoding: utf-8
class ParticipantsController < ApplicationController
  PER_PAGE = 50
  
  before_filter :set_current_tab
  
  def set_current_tab
    @current_tab = "enroll_parti_sp"
  end
  
  # GET /participants
  # GET /participants.xml
  def index
    scan_procedure_array = (current_user.view_low_scan_procedure_array).split(' ').map(&:to_i)
#    @search = Participant.where(" participants.id in ( select participant_id from enrollments where enrollments.id in (select enrollment_visit_memberships.enrollment_id from enrollment_visit_memberships where enrollment_visit_memberships.visit_id in
#     (select visit_id from scan_procedures_visits where scan_procedure_id in (?)))) ", scan_procedure_array).search(params[:search])
     
#     @search = Participant.where(" participants.id in ( select participant_id from enrollments where enrollments.id in (select enrollment_visit_memberships.enrollment_id
#      from enrollment_visit_memberships, scan_procedures_visits
#      where enrollment_visit_memberships.visit_id = scan_procedures_visits.visit_id and scan_procedures_visits.scan_procedure_id in (?))) ", scan_procedure_array).search(params[:search])
 
 @search = Participant.where(" participants.id in ( select participant_id from enrollments,enrollment_vgroup_memberships, scan_procedures_vgroups
      where enrollments.id = enrollment_vgroup_memberships.enrollment_id
     and  enrollment_vgroup_memberships.vgroup_id = scan_procedures_vgroups.vgroup_id and scan_procedures_vgroups.scan_procedure_id in (?)) ", scan_procedure_array).search(params[:search])
           
    @participants = @search.relation.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @participants }
    end
  end

  # GET /participants/1
  # GET /participants/1.xml
  def show
    scan_procedure_array = (current_user.view_low_scan_procedure_array).split(' ').map(&:to_i)
#    @participant = Participant.where(" participants.id in ( select participant_id from enrollments where enrollments.id in (select enrollment_visit_memberships.enrollment_id from enrollment_visit_memberships where enrollment_visit_memberships.visit_id in
#     (select visit_id from scan_procedures_visits where scan_procedure_id in (?)))) ", scan_procedure_array).find(params[:id])

     @participants = Participant.where("participants.id in ( select vgroups.participant_id from vgroups, scan_procedures_vgroups where vgroups.id = scan_procedures_vgroups.vgroup_id 
                    and vgroups.participant_id in (?) and scan_procedures_vgroups.scan_procedure_id in (?)) ", params[:id],scan_procedure_array)
     if(@participants.blank?)
         @participants = Participant.where("participants.id in ( select participant_id from enrollments where enrollments.id in (select enrollment_vgroup_memberships.enrollment_id from enrollment_vgroup_memberships, scan_procedures_vgroups
           where enrollment_vgroup_memberships.vgroup_id = scan_procedures_vgroups.vgroup_id and scan_procedures_vgroups.scan_procedure_id in (?))",scan_procedure_array)
     end
     # problems if no vgroup or enumber -- no way to link to scan procedure and access control
     @participant = @participants.find(params[:id])

     
      
     @vgroups = Vgroup.where("participant_id in ( select participant_id from enrollments where participant_id = ? and enrollments.id in (select enrollment_vgroup_memberships.enrollment_id from enrollment_vgroup_memberships, scan_procedures_vgroups
                  where enrollment_vgroup_memberships.vgroup_id = scan_procedures_vgroups.vgroup_id and scan_procedures_vgroups.scan_procedure_id in (?))) ", params[:id],scan_procedure_array)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @participant }
    end
  end

  # GET /participants/new
  # GET /participants/new.xml
  def new
    @participant = Participant.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @participant }
    end
  end

  # GET /participants/1/edit
  def edit
    scan_procedure_array = (current_user.edit_low_scan_procedure_array).split(' ').map(&:to_i)
#    @participant = Participant.where(" participants.id in ( select participant_id from enrollments where enrollments.id in (select enrollment_visit_memberships.enrollment_id from enrollment_visit_memberships where enrollment_visit_memberships.visit_id in
#     (select visit_id from scan_procedures_visits where scan_procedure_id in (?)))) ", scan_procedure_array).find(params[:id])
     @participant = Participant.where(" participants.id in ( select participant_id from enrollments where enrollments.id in 
     (select enrollment_vgroup_memberships.enrollment_id from enrollment_vgroup_memberships,scan_procedures_vgroups
      where enrollment_vgroup_memberships.vgroup_id = scan_procedures_vgroups.vgroup_id and  scan_procedures_vgroups.scan_procedure_id in (?))) ", scan_procedure_array).find(params[:id])
  end

  # POST /participants
  # POST /participants.xml
  def create
    @participant = Participant.new(params[:participant])
    if @participant.dob > 365.days.ago.to_date # form is setting a default date of today sometimes
       @participant.dob = nil
    end
    connection = ActiveRecord::Base.connection();
    if !params[:enumber].blank?
       @enrollment = Enrollment.where("participant_id is not NULL and enumber = ?",params[:enumber] )
       if !@enrollment.blank? 
         flash[:notice] = 'There is a participant with enumber '+params[:enumber]
       else
         @enrollment = Enrollment.where(" enumber = ?",params[:enumber] )               
       end         
     end
     if !params[:participant][:wrapnum].blank?
        @participant2 = Participant.where("wrapnum in (?)",params[:participant][:wrapnum] )
        if !@participant2.blank?
          flash[:notice] = 'There is a participant with wrapnumber '+params[:participant][:wrapnum]               
        end         
      end
      if !params[:participant][:reggieid].blank?
         @participant3 = Participant.where("reggieid = ?",params[:participant][:reggieid] )
         if !@participant3.blank?
           flash[:notice] = 'There is a participant with reggieid '+params[:participant][:reggieid]               
         end         
       end

    respond_to do |format|
      if (!@enrollment.blank? and !(@enrollment[0].participant_id).blank? ) or !@participant2.blank? or !@participant3.blank?
        format.html { render :action => "new" }
        format.xml  { render :xml => @participant.errors, :status => :unprocessable_entity }
      elsif @participant.save 
        sql = "update participants set wrapnum = NULL where trim(wrapnum) = '' "
        results = connection.execute(sql)
        sql = "update participants set reggieid = NULL where trim(reggieid) = '' "
        results = connection.execute(sql)
        if !params[:enumber].blank? and @enrollment.blank?
          sql = " insert into enrollments(enumber,participant_id)values('"+params[:enumber].gsub(/[;:'"()=<>]/, '')+"',"+@participant.id.to_s+")"
          results = connection.execute(sql)
        elsif !params[:enumber].blank? and !@enrollment.blank?
          sql = " update enrollments set participant_id = "+@participant.id.to_s+" where enumber ='"+params[:enumber].gsub(/[;:'"()=<>]/, '')+"' "
          results = connection.execute(sql)
        end
        flash[:notice] = 'Participant was successfully created.'
        format.html { redirect_to(participant_search_path) }
        format.xml  { render :xml => @participant, :status => :created, :location => @participant }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @participant.errors, :status => :unprocessable_entity }
      end
     end
  end

  # PUT /participants/1
  # PUT /participants/1.xml
  def update
    scan_procedure_array = (current_user.edit_low_scan_procedure_array).split(' ').map(&:to_i)
#    @participant = Participant.where(" participants.id in ( select participant_id from enrollments where enrollments.id in (select enrollment_visit_memberships.enrollment_id from enrollment_visit_memberships where enrollment_visit_memberships.visit_id in
#     (select visit_id from scan_procedures_visits where scan_procedure_id in (?)))) ", scan_procedure_array).find(params[:id])
     @participant = Participant.where(" participants.id in ( select participant_id from enrollments where enrollments.id in (select enrollment_vgroup_memberships.enrollment_id from enrollment_vgroup_memberships, scan_procedures_vgroups
                 where enrollment_vgroup_memberships.vgroup_id  =  scan_procedures_vgroups.vgroup_id and  scan_procedures_vgroups.scan_procedure_id in (?))) ", scan_procedure_array).find(params[:id])

    respond_to do |format|
      if @participant.update_attributes(params[:participant])
        sql = "update participants set wrapnum = NULL where trim(wrapnum) = '' "
        connection = ActiveRecord::Base.connection();
        results = connection.execute(sql)
        sql = "update participants set reggieid = NULL where trim(reggieid) = '' "
        results = connection.execute(sql)
        if @participant.dob > 365.days.ago.to_date # form is setting a default date of today sometimes
           @participant.dob = nil
           @participant.save
        end
        if !@participant.dob.blank?
           @appointments = Appointment.where("appointments.vgroup_id in (select vgroups.id from vgroups where participant_id is not null and participant_id in (?))", params[:id])
           @appointments.each do |appt|
              appt.age_at_appointment = ((appt.appointment_date - @participant.dob)/365.25).floor
              appt.save
           end
        end
        
        flash[:notice] = 'Participant was successfully updated.'
        format.html { redirect_to(@participant) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @participant.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def participant_search


        # possible params -- participants fields just get added as AND statements
        #   other table fields should be grouped into one lower level IN select 
        # scan_procedures_vgroups.scan_procedures_id
        # vgroups.rmr
        # vgroups.path
        # vgroups.date scan date before = latest_timestamp(1i)(2i)(3i)
        # vgroups.date scan date after  = earliest_timestamp(1i)(2i)(3i)
        #enrollment_vgroup_memberships.enrollment_id enrollments.enumber
        
        # age at ANY of the appointments
      
      @conditions = []
      params[:search] =Hash.new
       if params[:participant_search].nil?
            params[:participant_search] =Hash.new  
       end
       params["search_criteria"] = ""
        scan_procedure_array =current_user[:view_low_scan_procedure_array]
            scan_procedure_array = (current_user.view_low_scan_procedure_array).split(' ').map(&:to_i)

        if !params[:participant_search][:scan_procedure_id].blank?
              condition =" participants.id in (select enrollments.participant_id from participants,  enrollment_vgroup_memberships, enrollments, scan_procedures_vgroups
                              where enrollment_vgroup_memberships.enrollment_id = enrollments.id and enrollments.participant_id = participants.id
                           and  scan_procedures_vgroups.vgroup_id = enrollment_vgroup_memberships.vgroup_id
                           and scan_procedures_vgroups.scan_procedure_id in ("+params[:participant_search][:scan_procedure_id].join(',').gsub(/[;:'"()=<>]/, '')+"))"
              @conditions.push(condition)
              @scan_procedures = ScanProcedure.where("id in (?)",params[:participant_search][:scan_procedure_id])
              params["search_criteria"] = params["search_criteria"] +", "+@scan_procedures.sort_by(&:codename).collect {|sp| sp.codename}.join(", ").html_safe            
        end

        if !params[:participant_search][:enumber].blank?
            
            if params[:participant_search][:enumber].include?(',') # string of enumbers
             v_enumber =  params[:participant_search][:enumber].gsub(/ /,'').gsub(/'/,'').downcase
             v_enumber = v_enumber.gsub(/,/,"','")
             condition =" participants.id in (select enrollments.participant_id from participants,   enrollments
                                        where enrollments.participant_id = participants.id
                                          and lower(enrollments.enumber) in  ('"+v_enumber.gsub(/[;:"()=<>]/, '')+"'))"
          
            else 
            condition ="  participants.id in (select enrollments.participant_id from participants,   enrollments
                                        where enrollments.participant_id = participants.id
                                          and lower(enrollments.enumber) in (lower('"+params[:participant_search][:enumber].gsub(/[;:'"()=<>]/, '')+"')))"
             end
             @conditions.push(condition)
             params["search_criteria"] = params["search_criteria"] +",  enumber "+params[:participant_search][:enumber]
          end      

          if !params[:participant_search][:rmr].blank? 
              condition ="  participants.id in (select enrollments.participant_id from participants,  enrollment_vgroup_memberships, enrollments, scan_procedures_vgroups,vgroups
                                 where enrollment_vgroup_memberships.enrollment_id = enrollments.id and enrollments.participant_id = participants.id
                              and  scan_procedures_vgroups.vgroup_id = enrollment_vgroup_memberships.vgroup_id 
                              and vgroups.id = enrollment_vgroup_memberships.vgroup_id
                              and lower(vgroups.rmr) in (lower('"+params[:participant_search][:rmr].gsub(/[;:'"()=<>]/, '')+"')   ))"
              @conditions.push(condition)           
              params["search_criteria"] = params["search_criteria"] +",  RMR "+params[:participant_search][:rmr]
          end


 

            if !params[:participant_search][:wrapnum].blank?
   
              condition ="  participants.id in (select enrollments.participant_id from participants,  enrollments
                where enrollments.participant_id = participants.id 
                       and participants.wrapnum is not NULL and participants.wrapnum in (lower('"+params[:participant_search][:wrapnum].gsub(/[;:'"()=<>]/, '')+"')   ))"
              @conditions.push(condition)           
              params["search_criteria"] = params["search_criteria"] +",  Wrapnum "+params[:participant_search][:wrapnum]
            end
            
            if !params[:participant_search][:reggieid].blank?
   
             condition ="  participants.id in (select enrollments.participant_id from participants,   enrollments
                where  enrollments.participant_id = participants.id 
                       and participants.reggieid is not NULL and participants.reggieid in (lower('"+params[:participant_search][:reggieid].gsub(/[;:'"()=<>]/, '')+"')   ))"
              @conditions.push(condition)           
              params["search_criteria"] = params["search_criteria"] +",  reggieid "+params[:participant_search][:reggieid]
            end

         # NEED TO CHANGE TO BE FOR ANY APPOITMENT 
               #  build expected date format --- between, >, < 
      v_date_latest =""
      #want all three date parts
      if !params[:participant_search]["#{'latest_timestamp'}(1i)"].blank? && !params[:participant_search]["#{'latest_timestamp'}(2i)"].blank? && !params[:participant_search]["#{'latest_timestamp'}(3i)"].blank?
           v_date_latest = params[:participant_search]["#{'latest_timestamp'}(1i)"] +"-"+params[:participant_search]["#{'latest_timestamp'}(2i)"].rjust(2,"0")+"-"+params[:participant_search]["#{'latest_timestamp'}(3i)"].rjust(2,"0")
      end
      v_date_earliest =""
      #want all three date parts
      if !params[:participant_search]["#{'earliest_timestamp'}(1i)"].blank? && !params[:participant_search]["#{'earliest_timestamp'}(2i)"].blank? && !params[:participant_search]["#{'earliest_timestamp'}(3i)"].blank?
            v_date_earliest = params[:participant_search]["#{'earliest_timestamp'}(1i)"] +"-"+params[:participant_search]["#{'earliest_timestamp'}(2i)"].rjust(2,"0")+"-"+params[:participant_search]["#{'earliest_timestamp'}(3i)"].rjust(2,"0")
       end
      v_date_latest = v_date_latest.gsub(/[;:'"()=<>]/, '')
      v_date_earliest = v_date_earliest.gsub(/[;:'"()=<>]/, '')
      if v_date_latest.length>0 && v_date_earliest.length >0
        condition ="  participants.id in  (select vgroups.participant_id from vgroups where vgroups.vgroup_date between '"+v_date_earliest+"' and '"+v_date_latest+"' )"
        @conditions.push(condition)
        params["search_criteria"] = params["search_criteria"] +",  vvgroup date between "+v_date_earliest+" and "+v_date_latest
      elsif v_date_latest.length>0
        condition ="  participants.id  in (select vgroups.participant_id from vgroups where vgroups.vgroup_date < '"+v_date_latest+"'  )"
         @conditions.push(condition)
         params["search_criteria"] = params["search_criteria"] +",  vgroup date before "+v_date_latest 
      elsif  v_date_earliest.length >0
        condition ="  participants.id  in (select vgroups.participant_id from vgroups where vgroups.vgroup_date > '"+v_date_earliest+"' )"
         @conditions.push(condition)
         params["search_criteria"] = params["search_criteria"] +",  vgroup date after "+v_date_earliest
       end

       if !params[:participant_search][:gender].blank?
          condition ="  participants.gender in ("+params[:participant_search][:gender].gsub(/[;:'"()=<>]/, '')+") "
           @conditions.push(condition)
           if params[:participant_search][:gender] == 1
              params["search_criteria"] = params["search_criteria"] +",  sex is Male"
           elsif params[:participant_search][:gender] == 2
              params["search_criteria"] = params["search_criteria"] +",  sex is Female"
           end
       end   

         if !params[:participant_search][:min_age].blank? && params[:participant_search][:max_age].blank?
             condition ="   participants.id in (select enrollments.participant_id from participants,  enrollment_vgroup_memberships, enrollments, scan_procedures_vgroups,vgroups
                                where enrollment_vgroup_memberships.enrollment_id = enrollments.id and enrollments.participant_id = participants.id
                             and  scan_procedures_vgroups.vgroup_id = enrollment_vgroup_memberships.vgroup_id 
                             and vgroups.id = enrollment_vgroup_memberships.vgroup_id
                             and floor(DATEDIFF(vgroups.vgroup_date,participants.dob)/365.25) >= "+params[:participant_search][:min_age].gsub(/[;:'"()=<>]/, '')+"   )"
            @conditions.push(condition)
           params["search_criteria"] = params["search_criteria"] +",  age at visit >= "+params[:participant_search][:min_age]
         elsif params[:participant_search][:min_age].blank? && !params[:participant_search][:max_age].blank?
              condition ="  participants.id in (select enrollments.participant_id from participants,  enrollment_vgroup_memberships, enrollments, scan_procedures_vgroups,vgroups
                              where enrollment_vgroup_memberships.enrollment_id = enrollments.id and enrollments.participant_id = participants.id
                          and  scan_procedures_vgroups.vgroup_id = enrollment_vgroup_memberships.vgroup_id 
                          and vgroups.id = enrollment_vgroup_memberships.vgroup_id
                          and floor(DATEDIFF(vgroups.vgroup_date,participants.dob)/365.25) <= "+params[:participant_search][:max_age].gsub(/[;:'"()=<>]/, '')+"   )"
              @conditions.push(condition)
              params["search_criteria"] = params["search_criteria"] +",  age at visit <= "+params[:participant_search][:max_age]
         elsif !params[:participant_search][:min_age].blank? && !params[:participant_search][:max_age].blank?
            condition ="  participants.id in (select enrollments.participant_id from participants,  enrollment_vgroup_memberships, enrollments, scan_procedures_vgroups,vgroups
                            where enrollment_vgroup_memberships.enrollment_id = enrollments.id and enrollments.participant_id = participants.id
                        and  scan_procedures_vgroups.vgroup_id = enrollment_vgroup_memberships.vgroup_id 
                        and vgroups.id = enrollment_vgroup_memberships.vgroup_id
                        and floor(DATEDIFF(vgroups.vgroup_date,participants.dob)/365.25) between "+params[:participant_search][:min_age].gsub(/[;:'"()=<>]/, '')+" and "+params[:participant_search][:max_age].gsub(/[;:'"()=<>]/, '')+"   )"
            @conditions.push(condition)
            params["search_criteria"] = params["search_criteria"] +",  age at visit between "+params[:participant_search][:min_age]+" and "+params[:participant_search][:max_age]
         end

       # adjust columns and fields for html vs xls
       request_format = request.formats.to_s
       @html_request ="Y"
       case  request_format
         when "[text/html]","text/html" then # ? application/html
           @column_headers = ['DOB','Gender','Wrapnum','Reggieid','Years of Education','Notes','Apoe_e1','Apoe_e2','ADRC Number', 'Enroll Number'] # need to look up values
               # Protocol,Enumber,RMR,Appt_Date get prepended to the fields, appointment_note appended
           @column_number =   @column_headers.size
           @fields =["date_format(participants.dob,'%Y')","lookup_genders.description","participants.wrapnum","participants.reggieid","participants.ed_years","participants.note","participants.apoe_e1","participants.apoe_e2","participants.adrcnum","participants.id"] 
              # need to get enumber in line
            @left_join = ["LEFT JOIN lookup_genders on participants.gender = lookup_genders.id"] # left join needs to be in sql right after the parent table!!!!!!!
         else    
           @html_request ="N"          
            @column_headers = ['DOB','Gender','Wrapnum','Reggieid','Years of Education','Notes','Apoe_e1','Apoe_e2','ADRC Number', 'Enroll Number']# need to look up values
                  # Protocol,Enumber,RMR,Appt_Date get prepended to the fields, appointment_note appended
            @column_number =   @column_headers.size
            @fields =["date_format(participants.dob,'%Y')","lookup_genders.description","participants.wrapnum","participants.reggieid","participants.ed_years","participants.note","participants.apoe_e1","participants.apoe_e2","participants.adrcnum","participants.id"] 
              # need to get enumber in line
            @left_join = ["LEFT JOIN lookup_genders on participants.gender = lookup_genders.id"] # left join needs to be in sql right after the parent table!!!!!!!   
                        
                 
         end
       @tables =['participants'] # trigger joins --- vgroups and appointments by default
       @order_by =["participants.id desc"]

      @results = self.run_search_participant   # in the application controller
      @results_total = @results  # pageination makes result count wrong
      t = Time.now 
      if params["search_criteria"].blank?
        params["search_criteria"] = ""
      end
      @export_file_title ="Search Criteria: "+params["search_criteria"]+" "+@results_total.size.to_s+" records "+t.strftime("%m/%d/%Y %I:%M%p")

      ### LOOK WHERE TITLE IS SHOWING UP
      @collection_title = 'All Participants'
      @current_tab = "participants"

         #   export_record.gsub!('%28','(')
         #   export_record.gsub!('%29',')')

      respond_to do |format|
        format.xls # pet_search.xls.erb
        format.xml  { render :xml => @results }    # actually redefined in the xls page    
        format.html {@results = Kaminari.paginate_array(@results).page(params[:page]).per(50)} # pet_search.html.erb
      end



    #    render :template => "visits/participant_search"    
    
  end

  # DELETE /participants/1
  # DELETE /participants/1.xml
  def destroy
    scan_procedure_array = (current_user.edit_low_scan_procedure_array).split(' ').map(&:to_i)
#    @participant = Participant.where(" participants.id in ( select participant_id from enrollments where enrollments.id in (select enrollment_visit_memberships.enrollment_id from enrollment_visit_memberships where enrollment_visit_memberships.visit_id in
#     (select visit_id from scan_procedures_visits where scan_procedure_id in (?)))) ", scan_procedure_array).find(params[:id])
     
     @participant = Participant.where(" participants.id in ( select participant_id from enrollments where enrollments.id in 
     (select enrollment_vgroup_memberships.enrollment_id from enrollment_vgroup_memberships, scan_procedures_vgroups
      where enrollment_vgroup_memberships.vgroup_id = scan_procedures_vgroups.vgroup_id and  scan_procedures_vgroups.scan_procedure_id in (?))) ", scan_procedure_array).find(params[:id]) 
    @participant.destroy

    respond_to do |format|
      format.html { redirect_to(participants_url) }
      format.xml  { head :ok }
    end
  end
end
