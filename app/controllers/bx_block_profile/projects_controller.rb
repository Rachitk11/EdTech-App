module BxBlockProfile
  class ProjectsController < ApplicationController

    def index
     @projects = Project.all
     render json: ProjectSerializer.new(@projects, meta: {
        message: "Successfully Loaded"
      }).serializable_hash, status: :ok
    end

    def create
      @profile = current_user.profiles.find_by(profile_role:"jobseeker")
      if @profile.present?
        @project = BxBlockProfile::Project.new(project_params.merge({ profile_id: @profile.id} ))
        if @project.save
          create_associated_with
          render json: BxBlockProfile::ProjectSerializer.new(@project
          ).serializable_hash, status: :created
        else
          render json: {
            errors: format_activerecord_errors(@project.errors)
          }, status: :unprocessable_entity
        end
      else
        render json: {
          errors: format_activerecord_errors(@profile.errors)
        }, status: :unprocessable_entity
      end
    end

    def show
      project = BxBlockProfile::Project.find_by(id: params[:id])
      if project.present?
        render json: BxBlockProfile::ProjectSerializer.new(project, meta: {
          message: ""
        }).serializable_hash, status: :ok
      else
        render json:{meta: {message: "Record not found."}}
      end
    end

    def update
      project = BxBlockProfile::Project.find_by(id: params[:id])
      if project.present?
        project.update(project_params)
        render json: ProjectSerializer.new(project, meta: {
            message: "Project updated successfully"
          }).serializable_hash, status: :ok
      else
        render json: {
          errors: format_activerecord_errors(project.errors)
        }, status: :unprocessable_entity
      end
    end

    def destroy
      project = BxBlockProfile::Project.find_by(id: params[:id])
      if project&.destroy
        render json:{ meta: { message: "Project Removed"}}
      else
        render json:{meta: {message: "Record not found."}}
      end
    end

    private

    def current_user
      @account = AccountBlock::Account.find_by(id: @token.id)
    end

    def project_params
      params.require(:project).permit \
       :id,
       :project_name,
       :start_date,
       :end_date,
       :add_members,
       :url,
       :description,
       :make_projects_public
    end

    def create_associated_with
      associated = Associated.where(associated_with_name: params[:associated_with_name]).first
      if associated.present?
        AssociatedProject.create(project_id: @project.id, associated_id: associated.id)
      else
       associated = Associated.create(associated_with_name: params[:associated_with_name])
        AssociatedProject.create(project_id: @project.id, associated_id: associated.id)
      end
    end

  end
end
