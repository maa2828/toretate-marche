class CartsController < ApplicationController
  before_action :initialize_cart

  # GET /cart
  def show
    @cart_items = []
    @total = 0

    session[:cart]&.each do |product_id, item|
      product = Product.find_by(id: product_id)
      next unless product

      quantity = item['quantity'].to_i
      @cart_items << {
        product: product,
        quantity: quantity,
        subtotal: product.price * quantity
      }
      @total += product.price * quantity
    end

    render 'index'
  end

  # POST /cart/add_item/:product_id
  def add_item
    product = Product.find(params[:product_id])
    quantity = params[:quantity]&.to_i || 1

    # 在庫チェック
    if product.stock_quantity < quantity
      redirect_to product_path(product), alert: '在庫が不足しています'
      return
    end

    session[:cart][product.id.to_s] ||= { 'quantity' => 0 }
    session[:cart][product.id.to_s]['quantity'] += quantity

    redirect_to cart_path, notice: 'カートに追加しました'
  end

  # PATCH /cart/update_item/:product_id
  def update_item
    product = Product.find(params[:product_id])
    quantity = params[:quantity].to_i

    if quantity <= 0
      session[:cart].delete(product.id.to_s)
      redirect_to cart_path, notice: 'カートから削除しました'
    elsif quantity > product.stock_quantity
      redirect_to cart_path, alert: '在庫が不足しています'
    else
      session[:cart][product.id.to_s]['quantity'] = quantity
      redirect_to cart_path, notice: '数量を更新しました'
    end
  end

  # DELETE /cart/remove_item/:product_id
  def remove_item
    product_id = params[:product_id]
    session[:cart].delete(product_id)
    redirect_to cart_path, notice: 'カートから削除しました'
  end

  # DELETE /cart/clear
  def clear
    session[:cart] = {}
    redirect_to cart_path, notice: 'カートを空にしました'
  end

  private

  def initialize_cart
    session[:cart] ||= {}
  end
end
