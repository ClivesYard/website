class ApplicantsController < ApplicationController
  before_action :admin?, only: [:index, :accept]
  def new
    @applicant = Applicant.new
  end

  def create
    @applicant = Applicant.new(apply_params)
    if @applicant.save
      flash.now[:success] = "Application sent an email will be sent to you if you are choosen"
      ApplicationMailer.application_request(@applicant).deliver
      # @applicant.send_application_request
      render 'show'
    else
      flash.now[:alert] = "Error saving form"
      render 'new'
    end
  end
  def show
    @applicant = Applicant.find(params[:id])
  end
  def index
    @applicants = Applicant.where(status: "apply")
  end
  def accept
    @accepts = Applicant.find(params[:geek])
    @accepts.update_attributes(status: "accept")
    ApplicantMailer.applicant_accept(@accepts).deliver_now
    flash.now[:success] = "Good choice, an email was sent to the applicant"
    @applicants = Applicant.where(status: "accept")
  end
  private
  def apply_params
    params.require(:applicant).permit(:first_name, :last_name, :mobile_number, :email, :github)
  end
end
