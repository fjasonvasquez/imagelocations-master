class TaxonomiesController < ApplicationController
  # GET /taxonomies
  # GET /taxonomies.json
  def index
    @taxonomies = Taxonomy.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @taxonomies }
    end
  end

  # GET /taxonomies/1
  # GET /taxonomies/1.json
  def show
    @taxonomy = Taxonomy.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @taxonomy }
    end
  end
end
