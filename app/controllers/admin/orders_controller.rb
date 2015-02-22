class Admin::OrdersController < Admin::AdminController
	respond_to :html, :json
	
	has_scope :site
	
	
	def index
		@orders = apply_scopes(Order).page(params[:page]).per(params[:per_page])
		respond_with @orders
	end
	
	def new
		
		@order = Order.new()
		
	end
	
	
	def show
		@order = apply_scopes(Order).find(params[:id])
	end
	
	
	def destroy
		@order = apply_scopes(Order).find(params[:id])
	    @order.destroy

		respond_to do |format|
			format.html { redirect_to admin_orders_url() }
			format.json { head :no_content }
		end
	end
	
end
