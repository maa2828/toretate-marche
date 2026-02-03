class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: [:show, :edit, :update, :destroy, :toggle_status]
  before_action :authorize_seller!, only: [:new, :create, :edit, :update, :destroy, :toggle_status]
  before_action :authorize_owner!, only: [:edit, :update, :destroy, :toggle_status]

  def index
    if current_user&.seller?
      # 生産者の場合：公開商品と自分の全商品を表示
      @products = Product.published.includes(:seller, image_attachment: :blob)
      @my_products = current_user.products.includes(image_attachment: :blob)
    else
      # 購入者の場合：公開商品のみ表示
      @products = Product.published.includes(:seller, image_attachment: :blob)
    end
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

  # 新しく追加：ステータス切り替え
  def toggle_status
    new_status = @product.published? ? :draft : :published
    
    if @product.update(status: new_status)
      status_text = @product.published? ? '公開' : '非公開'
      redirect_to products_path, notice: "商品を#{status_text}にしました"
    else
      redirect_to products_path, alert: 'ステータスの変更に失敗しました'
    end
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
