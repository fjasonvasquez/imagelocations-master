class EntityTermsController < ApplicationController
  # GET /entity_terms
  # GET /entity_terms.json
  def index
    @entity_terms = EntityTerm.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @entity_terms }
    end
  end

  # GET /entity_terms/1
  # GET /entity_terms/1.json
  def show
    @entity_term = EntityTerm.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @entity_term }
    end
  end

  # GET /entity_terms/new
  # GET /entity_terms/new.json
  def new
    @entity_term = EntityTerm.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @entity_term }
    end
  end

  # GET /entity_terms/1/edit
  def edit
    @entity_term = EntityTerm.find(params[:id])
  end

  # POST /entity_terms
  # POST /entity_terms.json
  def create
    @entity_term = EntityTerm.new(params[:entity_term])

    respond_to do |format|
      if @entity_term.save
        format.html { redirect_to @entity_term, notice: 'Entity term was successfully created.' }
        format.json { render json: @entity_term, status: :created, location: @entity_term }
      else
        format.html { render action: "new" }
        format.json { render json: @entity_term.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /entity_terms/1
  # PUT /entity_terms/1.json
  def update
    @entity_term = EntityTerm.find(params[:id])

    respond_to do |format|
      if @entity_term.update_attributes(params[:entity_term])
        format.html { redirect_to @entity_term, notice: 'Entity term was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @entity_term.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entity_terms/1
  # DELETE /entity_terms/1.json
  def destroy
    @entity_term = EntityTerm.find(params[:id])
    @entity_term.destroy

    respond_to do |format|
      format.html { redirect_to entity_terms_url }
      format.json { head :no_content }
    end
  end
end
