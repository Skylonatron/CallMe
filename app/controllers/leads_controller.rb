class LeadsController < ApplicationController
  before_action :set_lead, only: [:show, :edit, :update, :destroy, :confirm, :call]
  before_action :authenticate_user!, except: [:confirm]

  # API
  def confirm
    @lead.update(called: :called)
    render json: { status: "200" }.to_json
  end

  # Web

  def upload_csv
  end

  def call
    twilio = TwilioIntegration.new

    phone_number = @lead.phone_number || @lead.phone_number_2
    if phone_number.length == 10
      phone_number = "1#{phone_number}"
    end

    @lead.update(called: :called)
    twilio.make_call(phone_number)

    flash[:notice] = "Automated Call has been placed"
    redirect_to leads_path
  end

  def upload_csv_post
    unless file = params[:file]
      @messages = "There was no file to import"
      render :upload_csv and return
    end

    import_leads = current_user.leads.import(file)

    if success = import_leads[:success]
      redirect_to(leads_path, notice: success)
    elsif error = import_leads[:fail]
      @messages = error
      render :upload_csv and return
    end

  end

  # GET /leads
  # GET /leads.json
  def index
    @leads = current_user.leads
    @buttons = [{ name: "New Leads (CSV)", path: upload_csv_leads_path}, {name: "New Lead", path: new_lead_path}]
    
    respond_to do |format|
      format.html { render :index }
      format.json { render json: @leads.uncalled.to_json }
    end
  end

  # GET /leads/1
  # GET /leads/1.json
  def show
  end

  # GET /leads/new
  def new
    @type = 'new'
    @lead = Lead.new
  end

  # GET /leads/1/edit
  def edit
    @type = 'edit'
  end

  # POST /leads
  # POST /leads.json
  def create
    @type = 'new'
    @lead = current_user.leads.new(lead_params)

    respond_to do |format|
      if @lead.save
        format.html { redirect_to leads_path, notice: 'Lead was successfully created.' }
        format.json { render :show, status: :created, location: @lead }
      else
        format.html { render :new }
        format.json { render json: @lead.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /leads/1
  # PATCH/PUT /leads/1.json
  def update
    @type = 'edit'
    respond_to do |format|
      if @lead.update(lead_params)
        format.html { redirect_to @lead, notice: 'Lead was successfully updated.' }
        format.json { render :show, status: :ok, location: @lead }
      else
        format.html { render :edit }
        format.json { render json: @lead.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /leads/1
  # DELETE /leads/1.json
  def destroy
    @lead.destroy
    respond_to do |format|
      format.html { redirect_to leads_url, notice: 'Lead was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lead
      @lead = Lead.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lead_params
      params.require(:lead).permit(:first_name, :last_name, :address, :city, :zip_code, :state, :phone_number, :phone_number_2, :email)
    end
end
