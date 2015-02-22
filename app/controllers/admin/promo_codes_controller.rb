class Admin::PromoCodesController < Admin::AdminController

	respond_to :html
	
	def index
  		@promo_codes = apply_scopes(PromoCode).page(params[:page]).per(params[:per_page])
  		respond_with @promo_codes
	end
	def new
    	@promo_code = PromoCode.new    
	end
	
	def show
		@promo_code = PromoCode.find(params[:id])
	end
	
	def edit
		@promo_code = PromoCode.find(params[:id])
	end
	
	def create
		@promo_code = PromoCode.new(params[:promo_code])
	
		respond_to do |format|
		  if @promo_code.save
		    format.html { redirect_to admin_promo_codes_url, notice: 'PromoCode was successfully created.' }
		    format.json { render json: @promo_code, status: :created, PromoCode: admin_promo_codes_url }
		  else
		    format.html { render action: "new" }
		    format.json { render json: @promo_code.errors, status: :unprocessable_entity }
		  end
		end
	end
	
	def update
		@promo_code = PromoCode.find(params[:id])
	
		respond_to do |format|
		  if @promo_code.update_attributes(params[:promo_code])
		    format.html { redirect_to admin_promo_codes_url, notice: 'PromoCode was successfully updated.' }
		    format.json { head :no_content }
		  else
		    format.html { render action: "edit" }
		    format.json { render json: @promo_code.errors, status: :unprocessable_entity }
		  end
		end
	end
	
	def destroy
		@promo_code = PromoCode.find(params[:id])
		@promo_code.destroy

	    respond_to do |format|
	      format.html { redirect_to admin_promo_codes_url }
	      format.json { head :no_content }
	    end
	end

end
