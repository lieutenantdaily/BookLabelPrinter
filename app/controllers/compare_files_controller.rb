class CompareFilesController < ApplicationController

    def index
        @compare_files = CompareFile.all.order("created_at DESC") 
        @compare_files_with_diff = CompareFile.where.not(difference: nil).order("CAST(difference AS Decimal) DESC") 
    
        respond_to do |format|
            format.html
              format.csv { send_data @compare_files_with_diff.to_csv, filename: "nebraska-compare-#{Date.today}.csv" }
        end
        @counter = CompareFile.all.count
        @counter2 = @compare_files_with_diff.all.count
    end

    def import_url
        CompareFile.import_url
        redirect_to compare_files_path, notice: "Nebraska Import Complete"
    end

    def import_url_tex
        CompareFile.import_url_tex
        redirect_to compare_files_path, notice: "Texas Import Complete"
    end

    def destroy_them_all
        CompareFile.delete_all
        redirect_to compare_files_path, notice: "Database has been reset!"
    end 

    def new
        @compare_file = CompareFile.new
    end

    def update
        @compare_file = CompareFile.find(params[:id])
    
        if @compare_file.update_attributes(compare_file_params)
          flash[:success] = "Task updated!"
          redirect_to url
        end
        
    end
    
    def create
        CompareFile.import(params[:compare_file][:file], params[:compare_file][:destination])
        # flash[:notice] = "Buybacks uploaded successfully"
        redirect_to compare_files_path
    end

    private def compare_file_params
        params.require(:compare_file).permit(:file, :destination) 
    end

end
