class TrtypesController < ApplicationController



  def trtype_home
    scan_procedure_array =  (current_user.view_low_scan_procedure_array).split(' ').map(&:to_i)
    @trtypes = Trtype.where("status_flag ='Y' ")
    connection = ActiveRecord::Base.connection();
    @v_action_name ="action"
    # SEARCH IS RETURNING TOO MANY - e.g. all mets if seach on pdt , because there was some pdt with mets dual enrollment

    if !params[:id].nil?

         @v_action_name = Trtype.find(params[:id]).action_name 
         @tractiontypes_search = Tractiontype.where("trtype_id in (?)",params[:id]).where("tractiontypes.display_search_flag = 'Y' ").order(:display_order)

         @trfiles = Trfile.where("trtype_id ="+params[:id]).where("trfiles.scan_procedure_id in (?)",scan_procedure_array)

         @conditions = ["scan_procedures.id = trfiles.scan_procedure_id ","trfiles.scan_procedure_id in ("+scan_procedure_array.join(',')+")"]
         if !params[:tr_search].nil?
           
            @trfiles_search = Trfile.where("trtype_id ="+params[:id]).where("trfiles.scan_procedure_id in (?)",scan_procedure_array).order("updated_at desc")
            if !@tractiontypes_search.nil? and !params[:tr_search][:tractiontype_id].nil?
                @tractiontypes_search.each do |act|
                  if !params[:tr_search][:tractiontype_id][(act.id).to_s].nil? and params[:tr_search][:tractiontype_id][(act.id).to_s] > ""
                    @trfiles_search = @trfiles_search.where("trfiles.id in (select tredits.trfile_id from tredits, tredit_actions where
                                                                      tredits.id = tredit_actions.tredit_id and tredit_actions.tractiontype_id in (?)
                                                                       and tredit_actions.value in (?) )",act.id, params[:tr_search][:tractiontype_id][(act.id).to_s])
                    @conditions.push(" trfiles.id in (select tredits.trfile_id from tredits, tredit_actions where
                                                                      tredits.id = tredit_actions.tredit_id and tredit_actions.tractiontype_id in ("+(act.id).to_s+")
                                                                       and tredit_actions.value in ("+params[:tr_search][:tractiontype_id][(act.id).to_s]+"))")
                   
                  end
                end
            end
            if !params[:tr_search][:subjectid].nil? and params[:tr_search][:subjectid] > ''
               v_subjectid_array = (params[:tr_search][:subjectid].gsub(/ /,"")).split(",")
  
               @trfiles_search = @trfiles_search.where("subjectid in (?)",v_subjectid_array) #params[:tr_search][:subjectid])
               @conditions.push(" trfiles.subjectid in ('"+params[:tr_search][:subjectid].gsub(/ /,"").gsub(/,/,"','")+"') ")
            end
            if !params[:tr_search][:secondary_key].nil? and params[:tr_search][:secondary_key] > ''
               @trfiles_search = @trfiles_search.where("secondary_key in (?)",params[:tr_search][:secondary_key])
               @conditions.push(" trfiles.secondary_key in ('"+params[:tr_search][:secondary_key]+"') ")
            end
            if !params[:tr_search][:trfile_id].nil? and params[:tr_search][:trfile_id] > ''
               @trfiles_search = @trfiles_search.where("id in (?)",params[:tr_search][:trfile_id])
               @conditions.push(" trfiles.id in ("+params[:tr_search][:trfile_id]+") ")
            end
            if !params[:tr_search][:scan_procedure_id].nil? and params[:tr_search][:scan_procedure_id] > ''
               @trfiles_search = @trfiles_search.where("scan_procedure_id in 
                        (select scan_procedure_id from scan_procedures_vgroups where 
                                              vgroup_id in (select vgroup_id from scan_procedures_vgroups where scan_procedure_id in (?))
                                              and enrollment_id in (select enrollment_id from enrollment_vgroup_memberships where vgroup_id in (select vgroup_id from scan_procedures_vgroups where scan_procedure_id in (?)) ))",params[:tr_search][:scan_procedure_id],params[:tr_search][:scan_procedure_id])
               @conditions.push("trfiles.scan_procedure_id in
                    (select scan_procedure_id from scan_procedures_vgroups where 
                                              vgroup_id in 
                                              (select vgroup_id from scan_procedures_vgroups where scan_procedure_id in 
                                                ("+params[:tr_search][:scan_procedure_id]+")))
                           and trfiles.enrollment_id in 
                            (select enrollment_id from enrollment_vgroup_memberships where 
                                              vgroup_id in 
                                              (select vgroup_id from scan_procedures_vgroups where scan_procedure_id in 
                                                ("+params[:tr_search][:scan_procedure_id]+"))) ")
            end
            if !params[:tr_search][:user_id].nil? and params[:tr_search][:user_id] > ''
               @trfiles_search = @trfiles_search.where("id in (select trfile_id from tredits where user_id in (?))",params[:tr_search][:user_id])
               @conditions.push(" trfiles.id in (select trfile_id from tredits where user_id in ("+params[:tr_search][:user_id]+")) ")
            end
            if !params[:tr_search][:file_completed_flag].nil? and params[:tr_search][:file_completed_flag] > ''
              @trfiles_search = @trfiles_search.where("file_completed_flag in (?)",params[:tr_search][:file_completed_flag])
               @conditions.push(" trfiles.file_completed_flag in('"+params[:tr_search][:file_completed_flag]+"') ")
            end
            if !params[:tr_search][:qc_value].nil? and params[:tr_search][:qc_value] > ''
              @trfiles_search = @trfiles_search.where("qc_value in (?)",params[:tr_search][:qc_value])
               @conditions.push(" trfiles.qc_value in('"+params[:tr_search][:qc_value]+"') ")
            end
         else
        # @trfiles_search = Trfile.where("trtype_id ="+params[:id]).where("updated_at >= DATE_SUB(NOW(), INTERVAL 120 DAY) ").where("trfiles.scan_procedure_id in (?)",scan_procedure_array).order("updated_at desc")
         @trfiles_search = Trfile.where("trtype_id ="+params[:id]).order("updated_at desc")
          @conditions.push(" trfiles.trtype_id ="+params[:id]+" ")
          #@conditions.push(" trfiles.updated_at >= DATE_SUB(NOW(), INTERVAL 120 DAY)")  # change to pageination
          
         end
         @export_file_title =Trtype.find(params[:id]).description+" file edits"
         @column_headers_display = ['Completed','Last Update','Subjectid','Add edit','Last edit','Scan Procedure','QC']
         @column_headers = ['Completed','Last Update','Subjectid','Scan Procedure','QC']

         
         @tractiontypes_search = Tractiontype.where("trtype_id in (?)",params[:id]).where("tractiontypes.display_search_flag = 'Y' ").order(:display_order)
         @tractiontypes = Tractiontype.where("trtype_id in (?)",params[:id]).where("tractiontypes.display_in_summary = 'Y' ").order(:display_order)
         @tractiontypes_peek = Tractiontype.where("trtype_id in (?)",params[:id]).where("tractiontypes.summary_peek_flag = 'Y' ").order(:display_order)

         # need count max number of edits for these trfiles
          sql = "select max(t1.cnt) from (select count(distinct tredits.id)  cnt from tredits  where status_flag ='Y' and trfile_id in (select trfiles.id from scan_procedures, trfiles where trfiles.trtype_id = "+params[:id]+" and "+@conditions.join(' and ')+" ) group by tredits.trfile_id ) t1"
          results =  connection.execute(sql)
          v_cnt_limit = (results.first)[0].to_i

         # add in trtype specific summary columns
         # if export -- do select 
         @html_request ="Y"
         request_format = request.formats.to_s
         case  request_format
          when "[text/html]","text/html" then
              @column_headers_display = ['Completed','Last Update','Subjectid', @v_action_name.humanize+' links','Scan Procedure','QC']
              for counter in  1..v_cnt_limit
                @column_headers_display.push(@v_action_name.humanize+' #'+counter.to_s)
                 @tractiontypes.each do |header|
                    @column_headers_display.push(header.display_summary_column_header_1)
                 end
              end
            else
              @html_request ="N"
             # @column_headers = ['Completed','Last Update','Subjectid','Scan Procedure','QC','QC Notes']
             # don't think this is used
              @db_columns   =["trfiles.file_completed_flag","trfiles.updated_at","concat(trfiles.subjectid,' ',trfiles.secondary_key)","scan_procedures.codename","trfiles.qc_value","trfiles.qc_notes"]
             # sql = "select "+@db_columns.join(",")+" from scan_procedures, trfiles where "+@conditions.join(' and ') 
             # connection = ActiveRecord::Base.connection();
             # @trfiles_search  =  connection.execute(sql)

              # making a select statement from tractiontype parts -- sort of like q_data

              @column_headers = ['Subjectid','Secondary Key','Scan Procedure','Last Update','Completed','QC','QC Notes']
              v_column_array = ["trfiles.subjectid","trfiles.secondary_key","trfiles.enrollment_id","trfiles.scan_procedure_id", "trfiles.file_completed_flag","trfiles.qc_value","trfiles.qc_notes"]
              v_column_array = ["trfiles.subjectid","trfiles.secondary_key","scan_procedures.codename","trfiles.updated_at", "trfiles.file_completed_flag","trfiles.qc_value","trfiles.qc_notes"]
              v_table_array = ["scan_procedures, trfiles"] # weird -- DO NOT JOIN ARRAY with comma 
               # need trfiles second for left join -- then joining the sql as a table --> no commas
              v_table_conditions =[" trfiles.trtype_id = "+params[:id]+" "]
              v_table_conditions.push(@conditions)
              @tractiontypes = Tractiontype.where("trtype_id in (?)",params[:id]).where("tractiontypes.form_display_label is not null and tractiontypes.form_display_label >''" ).order(:display_order)
              @tractiontypes.each do |act|
                 v_value_sql = ""
                 # ("trfiles.id = v_"+act.id.to_s+".trfile_id")
                 @column_headers.push(act.form_display_label)
                 v_col = (act.form_display_label).gsub(/ /,"").gsub(/\'/,"_").gsub(/\:/,"_").gsub(/\"/,"_").gsub(/\-/,"_").gsub(/\//,"_").downcase+"_" 
                 v_column_array.push("v_"+act.id.to_s+"."+v_col) 

                 # need last edit
                 if !act.ref_table_b_1.blank?
                     v_value_sql = "LEFT JOIN  (select "+act.ref_table_a_1+".description "+v_col+", trfile2.id  trfile_id from  trfiles trfile2, tredits , tredit_actions, "+act.ref_table_a_1+" 
                      where trfile2.id = tredits.trfile_id 
                      and tredits.id = tredit_actions.tredit_id 
                      and tredit_actions.tractiontype_id = "+act.id.to_s+" 
                      and "+act.ref_table_a_1+".label = '"+act.ref_table_b_1+"'
                      and tredit_actions.value = "+act.ref_table_a_1+".ref_value
                      and tredits.id in ( select max(tredit2.id) from tredits tredit2 where tredit2.trfile_id = trfile2.id) ) v_"+act.id.to_s+" on trfiles.id = v_"+act.id.to_s+".trfile_id "
                     v_table_array.push(v_value_sql)
                 elsif !act.ref_table_a_1.blank?
                    v_value_sql = "LEFT JOIN  (select "+act.ref_table_a_1.pluralize.underscore+".description "+v_col+", trfile2.id  trfile_id from  trfiles trfile2, tredits , tredit_actions, "+act.ref_table_a_1.pluralize.underscore+" 
                      where trfile2.id = tredits.trfile_id 
                      and tredits.id = tredit_actions.tredit_id 
                      and tredit_actions.tractiontype_id = "+act.id.to_s+" 
                      and "+act.ref_table_a_1+".label = '"+act.ref_table_b_1+"'
                      and tredit_actions.value = "+act.ref_table_a_1.pluralize.underscore+".id
                      and tredits.id in ( select max(tredit2.id) from tredits tredit2 where tredit2.trfile_id = trfile2.id) ) v_"+act.id.to_s+" on trfiles.id = v_"+act.id.to_s+".trfile_id "
                    v_table_array.push(v_value_sql)
                 else
                    v_value_sql = "LEFT JOIN (select tredit_actions.value "+v_col+", trfile2.id  trfile_id from  trfiles trfile2, tredits , tredit_actions 
                      where trfile2.id = tredits.trfile_id 
                      and tredits.id = tredit_actions.tredit_id 
                      and tredit_actions.tractiontype_id = "+act.id.to_s+" 
                      and tredits.id in ( select max(tredit2.id) from tredits tredit2 where tredit2.trfile_id = trfile2.id) ) v_"+act.id.to_s+" on trfiles.id = v_"+act.id.to_s+".trfile_id "
                    v_table_array.push(v_value_sql)
                end
              end
              # using LEFT JOIN
              @sql_view = "select * from ( select "+v_column_array.join(',')+" from "+v_table_array.join(' ')+" where "+v_table_conditions.join(' and ') +" ) t1"
              connection = ActiveRecord::Base.connection();
              @trfiles_search  =  connection.execute(@sql_view)

            end

         @column_number = @column_headers.size
    end

    
    respond_to do |format|
      format.xls 
      if !@trfiles_search.nil?
        @v_trfiles_search_size = @trfiles_search.size
         format.html {@trfiles_search = Kaminari.paginate_array(@trfiles_search).page(params[:page]).per(100)}# index.html.erb
      else
          format.html
      end
      #format.json { render json: @trtypes }
    end
  end
  # GET /trtypes
  # GET /trtypes.json
  def index
    @trtypes = Trtype.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @trtypes }
    end
  end

  # GET /trtypes/1
  # GET /trtypes/1.json
  def show
    @trtype = Trtype.find(params[:id])
    # want to make sql for view
    v_column_array = ["trfiles.subjectid","trfiles.secondary_key","trfiles.enrollment_id","trfiles.scan_procedure_id", "trfiles.file_completed_flag","trfiles.qc_value","trfiles.qc_notes"]
    v_table_array = ["trfiles"]
    v_table_conditions =["trfiles.trtype_id = "+params[:id]+" "]

    @tractiontypes = Tractiontype.where("trtype_id in (?)",params[:id]).where("tractiontypes.form_display_label is not null and tractiontypes.form_display_label >''" ).order(:display_order)
    @tractiontypes.each do |act|
        v_value_sql = ""
        # ("trfiles.id = v_"+act.id.to_s+".trfile_id")
        v_col = (act.form_display_label).gsub(/ /,"").gsub(/\'/,"_").gsub(/\"/,"_").gsub(/\-/,"_").downcase+"_" 
        v_column_array.push("v_"+act.id.to_s+"."+v_col) 
        # need last edit
        if !act.ref_table_b_1.blank?
          v_value_sql = "LEFT JOIN  (select "+act.ref_table_a_1+".description "+v_col+", trfile2.id  trfile_id from  trfiles trfile2, tredits , tredit_actions, "+act.ref_table_a_1+" 
                      where trfile2.id = tredits.trfile_id 
                      and tredits.id = tredit_actions.tredit_id 
                      and tredit_actions.tractiontype_id = "+act.id.to_s+" 
                      and "+act.ref_table_a_1+".label = '"+act.ref_table_b_1+"'
                      and tredit_actions.value = "+act.ref_table_a_1+".ref_value
                      and tredits.id in ( select max(tredit2.id) from tredits tredit2 where tredit2.trfile_id = trfile2.id) ) v_"+act.id.to_s+" on trfiles.id = v_"+act.id.to_s+".trfile_id "
         v_table_array.push(v_value_sql)

        elsif !act.ref_table_a_1.blank?
          v_value_sql = "LEFT JOIN  (select "+act.ref_table_a_1.pluralize.underscore+".description "+v_col+", trfile2.id  trfile_id from  trfiles trfile2, tredits , tredit_actions, "+act.ref_table_a_1.pluralize.underscore+" 
                      where trfile2.id = tredits.trfile_id 
                      and tredits.id = tredit_actions.tredit_id 
                      and tredit_actions.tractiontype_id = "+act.id.to_s+" 
                      and "+act.ref_table_a_1+".label = '"+act.ref_table_b_1+"'
                      and tredit_actions.value = "+act.ref_table_a_1.pluralize.underscore+".id
                      and tredits.id in ( select max(tredit2.id) from tredits tredit2 where tredit2.trfile_id = trfile2.id) ) v_"+act.id.to_s+" on trfiles.id = v_"+act.id.to_s+".trfile_id "
         v_table_array.push(v_value_sql)

        else
          v_value_sql = "LEFT JOIN (select tredit_actions.value "+v_col+", trfile2.id  trfile_id from  trfiles trfile2, tredits , tredit_actions 
                      where trfile2.id = tredits.trfile_id 
                      and tredits.id = tredit_actions.tredit_id 
                      and tredit_actions.tractiontype_id = "+act.id.to_s+" 
                      and tredits.id in ( select max(tredit2.id) from tredits tredit2 where tredit2.trfile_id = trfile2.id) ) v_"+act.id.to_s+" on trfiles.id = v_"+act.id.to_s+".trfile_id "
         v_table_array.push(v_value_sql)
        end
    end
    # using LEFT JOIN
    @sql_view = "select * from ( select "+v_column_array.join(',')+" from "+v_table_array.join(' ')+" where "+v_table_conditions.join(' and ') +" ) t1"


    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @trtype }
    end
  end

  # GET /trtypes/new
  # GET /trtypes/new.json
  def new
    @trtype = Trtype.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @trtype }
    end
  end

  # GET /trtypes/1/edit
  def edit
    @trtype = Trtype.find(params[:id])
  end

  # POST /trtypes
  # POST /trtypes.json
  def create
    @trtype = Trtype.new(params[:trtype])

    respond_to do |format|
      if @trtype.save
        format.html { redirect_to @trtype, notice: 'Trtype was successfully created.' }
        format.json { render json: @trtype, status: :created, location: @trtype }
      else
        format.html { render action: "new" }
        format.json { render json: @trtype.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /trtypes/1
  # PUT /trtypes/1.json
  def update
    @trtype = Trtype.find(params[:id])

    respond_to do |format|
      if @trtype.update_attributes(params[:trtype])
        format.html { redirect_to @trtype, notice: 'Trtype was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @trtype.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trtypes/1
  # DELETE /trtypes/1.json
  def destroy
    @trtype = Trtype.find(params[:id])
    @trtype.destroy

    respond_to do |format|
      format.html { redirect_to trtypes_url }
      format.json { head :no_content }
    end
  end
end
