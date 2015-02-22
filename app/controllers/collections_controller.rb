class CollectionsController < ApplicationController

	def email
		
		@email = Email.new(params[:email])
		@collection = Collection.new(params[:collection])
		
		@element = params[:element] unless params[:element].nil?
		
		
		if EntityMailer.collection_email(@email,@collection).deliver
			@message = I18n.t 'collections.email.sent'
		else
			@message = I18n.t 'collections.email.error'
		end
		
	end

	def download
		 @collection = Collection.new(params[:collection])

		 respond_to do |format|
			 format.pdf do
				render :pdf => "collection",
						:template => "collections/pdf",
				 		:layout => "pdf",
				 		:margin => {
					 		:bottom => 30
				 		},
				 		:footer => {
					 		:html => {
						 		:template => "shared/pdf_footer"
					 		}
				 		}
			  end
	     end
	end
	
end
