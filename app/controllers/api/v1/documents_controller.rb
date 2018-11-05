class Api::V1::DocumentsController < ApplicationController
  respond_to :json

  def show
    # respond_with User.find(params[:id])
  end

  private

  def document_params
    # params.require(:user).permit(:email, :password, :password_confirmation)
  end
end