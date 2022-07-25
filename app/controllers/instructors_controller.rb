class InstructorsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_instructor_not_found_response
    rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_instuctor_response

    def index
        instructors = Instructor.all
        render json: instructors
    end

    def show
        instructor = find_instructor
        render json: instructor, include: :students
    end

    def create
        instructor = Instructor.create!(instructor_params)
        render json: instructor
    end

    def update
        instructor = find_instructor
        instructor.update!(instructor_params)
        render json: instructor
    end

    def destroy
        instructor = find_instructor
        instructor.destroy
        head :no_content
    end

private

    def find_instructor
        Instructor.find_by!(id: params[:id])
    end

    def render_instructor_not_found_response
        render json: { errors: "Instructor not found" }, status: :not_found
    end

    def instructor_params
        params.permit(:name)
    end

    def render_invalid_instuctor_response(invalid)
        render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
    end

end
