class MembershipsController < ApplicationController
  before_action :set_membership, only: [:show, :edit, :update, :destroy]
  before_action :ensure_that_signed_in, only: [:confirm]

  # GET /memberships
  # GET /memberships.json
  def index
    @memberships = Membership.all
  end

  # GET /memberships/1
  # GET /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    @membership = Membership.new
    @beer_clubs = BeerClub.all.reject { |club| club.users.include? current_user }
  end

  # GET /memberships/1/edit
  def edit
    @beer_clubs = BeerClub.all.reject { |club| club.users.include? current_user }
  end

  # POST /memberships
  # POST /memberships.json
  def create
    @membership = Membership.new(membership_params)
    @membership.user = current_user

    respond_to do |format|
      if @membership.save
        format.html { redirect_to @membership.beer_club, notice: "Welcome to #{@membership.beer_club.name}, #{current_user.username}!" }
        format.json { render :show, status: :created, location: @membership.beer_club }
      else
        @beer_clubs = BeerClub.all
        format.html { render :new }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /memberships/1
  # PATCH/PUT /memberships/1.json
  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to @membership, notice: 'Membership was successfully updated.' }
        format.json { render :show, status: :ok, location: @membership }
      else
        format.html { render :edit }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memberships/1
  # DELETE /memberships/1.json
  def destroy
    @membership.destroy
    respond_to do |format|
      format.html { redirect_to current_user, notice: "Membership in #{@membership.beer_club.name} was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def confirm
    membership = Membership.find(params[:id])

    return if membership.nil?

    if current_user && membership.user == current_user
      redirect_to membership.beer_club, notice: "you can't confirm yourself!"
      return
    end

    membership.confirmed = true
    membership.save

    redirect_to membership.beer_club, notice: "membership of #{membership.user.username} confirmed"
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_membership
    @membership = Membership.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def membership_params
    params.require(:membership).permit(:beer_club_id, :user_id)
  end
end
