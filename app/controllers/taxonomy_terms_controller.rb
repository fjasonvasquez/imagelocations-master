class TaxonomyTermsController < ApplicationController
  # GET /taxonomy_terms
  # GET /taxonomy_terms.json
  def index
    @taxonomy_terms = TaxonomyTerm.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @taxonomy_terms }
    end
  end

  # GET /taxonomy_terms/1
  # GET /taxonomy_terms/1.json
  def show
    @taxonomy_term = TaxonomyTerm.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @taxonomy_term }
    end
  end
end
