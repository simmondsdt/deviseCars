class CarsController < ApplicationController
  before_action :set_car, except: [:index, :new, :create, :all_cars]

  def index
    @cars = current_user.cars.all
  end

  def show
  end

  def new
    @car = current_user.cars.new
  end

  def create
    @car = current_user.cars.new(car_params)
    if @car.save
      flash[:success] = 'Car created successfully!'
      redirect_to car_path(@car)
    else
      flash[:error] = 'Something went wrong!'
      render :new
    end
  end

  def edit
    if current_user.id != @car.user_id
      flash[:error] = 'That car does not belong to you!'
      redirect_to all_cars_path
    end
  end

  def update
    if @car.update
      redirect_to car_path(@car), success: 'Car edited successfully!'
    else
      render :edit, error: 'Something went wrong!'
    end
  end

  def destroy
    if current_user.id != @car.user_id
      flash[:error] = 'That car does not belong to you!'
      redirect_to all_cars_path
    else
      @car.destroy
      redirect_to cars_path, success: 'Car was deleted!'
    end
  end

  def all_cars
    @cars = Car.all
  end

  private
    def car_params
      params.require(:car).permit(:make, :year, :model, :runs,
                                  :engine, :number_of_doors)
    end

    def set_car
      @car = Car.find(params[:id])
    end
end
