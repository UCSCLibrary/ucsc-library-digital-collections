class GithubCredentialsController < ApplicationController
  before_action :set_github_credential, only: [:show, :edit, :update, :destroy]

  # GET /github_credentials
  # GET /github_credentials.json
  def index
    @github_credentials = GithubCredential.all
  end

  # GET /github_credentials/1
  # GET /github_credentials/1.json
  def show
  end

  # GET /github_credentials/new
  def new
    @github_credential = GithubCredential.new
  end

  # GET /github_credentials/1/edit
  def edit
  end

  # POST /github_credentials
  # POST /github_credentials.json
  def create
    @github_credential = GithubCredential.new(github_credential_params)

    respond_to do |format|
      if @github_credential.save
        format.html { redirect_to @github_credential, notice: 'Github credential was successfully created.' }
        format.json { render :show, status: :created, location: @github_credential }
      else
        format.html { render :new }
        format.json { render json: @github_credential.errors, status: :unprocessable_entity }
      end
    end
  end

  def authenticate
     respond_to do |format|
        format.html { render :text => "<h1> Here are some params:</h1>#{params}"}
        format.json { render :show, status: :ok, location: @github_credential }
    end
  end

  # PATCH/PUT /github_credentials/1
  # PATCH/PUT /github_credentials/1.json
  def update
    respond_to do |format|
      if @github_credential.update(github_credential_params)
        format.html { redirect_to @github_credential, notice: 'Github credential was successfully updated.' }
        format.json { render :show, status: :ok, location: @github_credential }
      else
        format.html { render :edit }
        format.json { render json: @github_credential.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /github_credentials/1
  # DELETE /github_credentials/1.json
  def destroy
    @github_credential.destroy
    respond_to do |format|
      format.html { redirect_to github_credentials_url, notice: 'Github credential was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_github_credential
      @github_credential = GithubCredential.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def github_credential_params
      params.require(:github_credential).permit(:user_id, :username, :oauth_code)
    end
end
