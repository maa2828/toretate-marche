class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :authorize_seller!, only: [:new, :create, :edit, :update, :destroy]
  before_action :authorize_owner!, only: [:edit, :update, :destroy]

  def index
    @products = Product.published_items.includes(:seller, image_attachment: :blob)
  end

  def show
  end

  def new
    @product = current_user.products.build
  end

  def create
    @product = current_user.products.build(product_params)
    
    if @product.save
      redirect_to @product, notice: '商品を出品しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to @product, notice: '商品を更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path, notice: '商品を削除しました'
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:title, :description, :price, :stock_quantity, :status, :image)
  end

  def authorize_seller!
    unless current_user.seller?
      redirect_to root_path, alert: '生産者のみ出品できます'
    end
  end

  def authorize_owner!
    unless @product.seller == current_user
      redirect_to root_path, alert: '権限がありません'
    end
  end
end
