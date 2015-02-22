class Admin::StatesController < Admin::AdminController
  include EntityMethods::Controller
  
  respond_to :html, :xml, :json
  
  has_scope :by_country
  
  #has_scope :site, :only => [:index]
  
  def index
    @states = apply_scopes(State).page(params[:page]).per(params[:per_page])
    respond_with @states
  end


  def show
  	@state = State.find(params[:id])
  	@cities = apply_scopes(@state.cities).uniq.page(params[:page]).per(params[:per_page])
  	
  	ap @cities
  	
  	respond_with @state
  end
  
  def edit
  	@state = State.find(params[:id])
  	set_site_entities @state
  	respond_with @state
  end
  
  def update
  	@state = State.find(params[:id])
   
    respond_to do |format|
      if @state.update_attributes(params[:state])
        format.html { redirect_to admin_state_path(@state), notice: 'State was successfully updated.' }
        format.json { head :no_content }
      else
      	set_site_entities @state
        format.html { render action: "edit" }
        format.json { render json: @state.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  	@state = State.find(params[:id])

    respond_to do |format|
	    if @state.destroy
			format.html { redirect_to admin_states_path }
			format.json { head :no_content }
		else
			format.html { redirect_to admin_state_path(@state) }
			format.json { render json: @state.errors, status: :unprocessable_entity }
	      
	    end
	 end
  end
  
  def remove_site_scope?
	  true
  end

end
