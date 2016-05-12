class PeopleController < ApplicationController
  def index
    @people = Person.order('age')
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

  private

  def person_params
    params.require(:person).permit(:name, :age, :occupation)
  end
end
