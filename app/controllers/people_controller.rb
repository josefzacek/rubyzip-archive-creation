class PeopleController < ApplicationController
  def index
    @people = Person.order('age')
    @number_of_records = Person.count
  end

  def show
    @person = Person.find(params[:id])
  end

  def new
    @person = Person.new
  end

  def create
    @person = Person.new(person_params)
    if @person.save
      flash[:notice] = "#{@person.name} successfully created"
      redirect_to action: 'show', id: @person.id
    else
      render 'new'
    end
  end

  def edit
    @person = Person.find(params[:id])
  end

  def update
    @person = Person.find(params[:id])
    if @person.update_attributes(person_params)
      flash[:notice] = "#{@person.name} successfully updated"
      redirect_to action: 'show', id: @person.id
    else
      render 'edit'
    end
  end

  def destroy
    @person = Person.find(params[:id])
    @person.destroy
    flash[:notice] = "#{@person.name} successfully deleted"
    redirect_to action: 'index'
  end

  def download_zip
    @people = Person.all
    if !@people.blank?
      compressed_file = Person.download_zip(@people)
      send_data compressed_file.read, filename: "People record generated on #{Time.now.strftime("%d-%m-%Y at %H:%M")}.zip"
    else
      flash[:notice] = 'There are no records in database'
      redirect_to action: 'index'
    end
  end

  def generate_exel_spreadsheet
    @people = Person.order('age')
    respond_to do |format|
      format.xlsx {
        response.headers['Content-Disposition'] = 'attachement; filename="all_people.xlsx"'
      }
    end
  end

  private

  def person_params
    params.require(:person).permit(:name, :age, :occupation)
  end
end
