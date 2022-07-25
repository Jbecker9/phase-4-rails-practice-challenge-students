class StudentsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_student_not_found_response
    rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_student_response

    def index
        students = Student.all
        render json: students
    end

    def show
        student = find_student
        render json: student, include: :instructor
    end

    def create
        student = Student.create!(student_params)
        render json: student, include: :instructor
    end

    def update
        student = find_student
        student.update!(student_params)
        render json: student, include: :instructor
    end

    def destroy
        student = find_student
        student.destroy
        head :no_content
    end

private 

    def find_student
        Student.find_by!(id: params[:id])
    end

    def student_params
        params.permit(:name, :age, :major, :instructor_id)
    end

    def render_student_not_found_response
        render json: { errors: "Student not found" }, status: :not_found
    end

    def render_invalid_student_response(invalid)
        render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
    end

end
