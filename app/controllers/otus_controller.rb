class OtusController < ApplicationController
  include DataControllerConfiguration::ProjectDataControllerConfiguration

  before_action :set_otu, only: [:show, :edit, :update, :destroy, :collection_objects]

  # GET /otus
  # GET /otus.json
  # @return [Ignored]
  def index
    # see app/views/otus/index.json.jbuilder
  end

  # @return [Ignored]
  def index
    respond_to do |format|
      format.html do
        @recent_objects = Otu.recent_from_project_id(sessions_current_project_id).order(updated_at: :desc).limit(10)
        render '/shared/data/all/index'
      end
      format.json {
        @otus = Otu.where(filter_params).with_project_id(sessions_current_project_id)
      }
    end
  end

  # GET /otus/1
  # GET /otus/1.json
  # @return [Ignored]
  def show
    # see app/views/otus/show.html.erb
    # see app/views/otus/show.json.jbuilder
  end

  # GET /otus/new
  # @return [Ignored]
  def new
    @otu = Otu.new
  end

  # GET /otus/1/edit
  # @return [Ignored]
  def edit
    # see app/views/otus/edit.html.erb
  end

  # @return [Ignored]
  def list
    @otus = Otu.with_project_id(sessions_current_project_id).page(params[:page])
  end

  # POST /otus
  # POST /otus.json
  # @return [Ignored]
  def create
    @otu = Otu.new(otu_params)

    respond_to do |format|
      if @otu.save
        format.html { redirect_to @otu,
                                  notice: "Otu '#{@otu.name}' was successfully created." }
        format.json { render action: :show, status: :created, location: @otu }
      else
        format.html { render action: 'new' }
        format.json { render json: @otu.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /otus/1
  # PATCH/PUT /otus/1.json
  # @return [Ignored]
  def update
    respond_to do |format|
      if @otu.update(otu_params)
        format.html { redirect_to @otu, notice: 'Otu was successfully updated.' }
        format.json { render :show, location: @otu }
      else
        format.html { render action: 'edit' }
        format.json { render json: @otu.errors, status: :unprocessable_entity }
      end
    end
  end

  # rubocop:disable Rails/SaveBang
  # DELETE /otus/1
  # DELETE /otus/1.json
  # @return [Ignored]
  def destroy
    @otu.destroy
    respond_to do |format|
      format.html { redirect_to otus_url }
      format.json { head :no_content }
    end
  end

  # GET /api/v1/otus/1/collection_objects
  # @return [Ignored]
  def collection_objects
    @collection_objects = Otu.find(params[:id]).collection_objects.pluck(:id)
  end

  # @return [Ignored]
  def search
    if params[:id].blank?
      redirect_to otus_path, notice: 'You must select an item from the list with a click or tab press before clicking show.'
    else
      redirect_to otu_path(params[:id])
    end
  end

  # @return [Ignored]
  def autocomplete
    @otus = Queries::Otu::Autocomplete.new(params.require(:term), project_id: sessions_current_project_id).all

    data = @otus.collect do |t|
      {
        id:              t.id,
        label:           ApplicationController.helpers.otu_autocomplete_selected_tag(t),
        gid:             t.to_global_id.to_s,
        response_values: {
          params[:method] => t.id
        },
        label_html:      ApplicationController.helpers.otu_tag(t)
      }
    end

    render json: data
  end

  # @return [Ignored]
  def batch_load
    # see app/views/otus/batch_load.html.erb
  end

  # @return [Ignored]
  def preview_simple_batch_load
    if params[:file]
      @result = BatchLoad::Import::Otus.new(batch_params.merge(user_map))
      digest_cookie(params[:file].tempfile, :batch_otus_md5)
      render('otus/batch_load/simple/preview')
    else
      flash[:notice] = 'No file provided!'
      redirect_to action: :batch_load
    end
  end

  # @return [Ignored]
  def create_simple_batch_load
    if params[:file] && digested_cookie_exists?(params[:file].tempfile, :batch_otus_md5)
      @result = BatchLoad::Import::Otus.new(batch_params.merge(user_map))
      if @result.create
        flash[:notice] = "Successfully processed file, #{@result.total_records_created} otus were created."
        render('otus/batch_load/simple/create') and return
      else
        flash[:alert] = 'Batch import failed.'
      end
      render(:batch_load)
    end
  end

  # @return [Ignored]
  def preview_identifiers_batch_load
    if params[:file]
      @result = BatchLoad::Import::Otus::IdentifiersInterpreter.new(batch_params)
      digest_cookie(params[:file].tempfile, :batch_load_otus_identifiers_md5)
      render('otus/batch_load/identifiers/preview')
    else
      flash[:notice] = 'No file provided!'
      redirect_to action: :batch_load
    end
  end

  # @return [Ignored]
  def create_identifiers_batch_load
    if params[:file] && digested_cookie_exists?(params[:file].tempfile, :batch_load_otus_identifiers_md5)
      @result = BatchLoad::Import::Otus::IdentifiersInterpreter.new(batch_params)
      if @result.create
        flash[:notice] = "Successfully processed file, #{@result.total_records_created} otus were created."
        render('otus/batch_load/identifiers/create')
        return
      else
        flash[:alert] = 'Batch import failed.'
      end
      render(:batch_load)
    end
  end

  # @return [Ignored]
  def preview_simple_batch_file_load
    if params[:files]
      @result = BatchFileLoad::Import::Otus::SimpleInterpreter.new(batch_params)
      digest_cookie(params[:files][0].tempfile, :batch_file_load_simple_md5)
      render 'otus/batch_file_load/simple/preview'
    else
      flash[:notice] = 'No file(s) provided!'
      redirect_to action: :batch_load
    end
  end

  # @return [Ignored]
  def create_simple_batch_file_load
    if params[:files] && digested_cookie_exists?(params[:files][0].tempfile, :batch_file_load_simple_md5)
      @result = BatchFileLoad::Import::Otus::SimpleInterpreter.new(batch_params)

      if @result.create
        flash[:notice] = "Successfully processed #{@result.total_files_processed} file(s), #{@result.total_records_created} otus were created."
        render 'otus/batch_file_load/simple/create'
        return
      else
        flash[:alert] = 'Batch import failed.'
        render :batch_load
      end
    end
  end

  # GET /otus/download
  # @return [Ignored]
  def download
    send_data Download.generate_csv(Otu.where(project_id: sessions_current_project_id)), type: 'text', filename: "otus_#{DateTime.now}.csv"
  end

  # GET api/v1/otus/by_name/:name?token=:token&project_id=:id
  # @return [Ignored]
  def by_name
    @otu_name = params.require(:name)
    @otu_ids  = Queries::Otu::Autocomplete.new(@otu_name, project_id: params.require(:project_id)).all.pluck(:id)
  end

  # @return [Ignored]
  def select_options
    @otus = Otu.select_optimized(sessions_current_user_id, sessions_current_project_id, params.require(:target))
  end

  private

  # @return [Ignored]
  def set_otu
    @otu           = Otu.with_project_id(sessions_current_project_id).find(params[:id])
    @recent_object = @otu
  end

  # @return [ActionController::Parameters]
  def otu_params
    params.require(:otu).permit(:name, :taxon_name_id)
  end

  # @return [ActionController::Parameters]
  def batch_params
    params.permit(:name, :file, :import_level, files: [])
      .merge(user_id:    sessions_current_user_id,
             project_id: sessions_current_project_id)
      .to_h
      .symbolize_keys
  end

  # @return [ActionController::Parameters]
  def filter_params
    params.permit(:taxon_name_id)
  end

  # rubocop:disable Style/StringHashKeys
  # @return [Ignored]
  def user_map
    {user_header_map: {'otu' => 'otu_name'}}
  end
  # rubocop:enable Style/StringHashKeys
  # rubocop:enable Rails/SaveBang
end
