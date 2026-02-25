class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :initialize_cart

  # GET /orders/new - 注文確認画面
  def new
    if session[:cart].blank?
      redirect_to cart_path, alert: 'カートが空です'
      return
    end

    @cart_items = []
    @total = 0

    session[:cart].each do |product_id, item|
      product = Product.find_by(id: product_id)
      next unless product

      quantity = item['quantity'].to_i
      
      # 在庫チェック
      if product.stock_quantity < quantity
        redirect_to cart_path, alert: "#{product.title}の在庫が不足しています"
        return
      end

      @cart_items << {
        product: product,
        quantity: quantity,
        subtotal: product.price * quantity
      }
      @total += product.price * quantity
    end
  end

  # POST /orders - 注文作成
  def create
    if session[:cart].blank?
      redirect_to cart_path, alert: 'カートが空です'
      return
    end

    ActiveRecord::Base.transaction do
      # 注文作成
      @order = current_user.orders.build(
        status: :pending,
        total_amount: 0
      )

      total = 0

      session[:cart].each do |product_id, item|
        product = Product.find(product_id)
        quantity = item['quantity'].to_i

        # 在庫チェック
        if product.stock_quantity < quantity
          raise ActiveRecord::Rollback, "#{product.title}の在庫が不足しています"
        end

        # 注文明細作成
        @order.order_items.build(
        product: product,
        quantity: quantity,
        price_snapshot: product.price,
        title_snapshot: product.title
        )

        # 在庫を減らす
        product.update!(stock_quantity: product.stock_quantity - quantity)
        
        total += product.price * quantity
      end

      @order.total_amount = total

      if @order.save
        # カートを空にする
        session[:cart] = {}
        redirect_to order_path(@order), notice: '注文が完了しました'
      else
        redirect_to new_order_path, alert: '注文に失敗しました'
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    redirect_to cart_path, alert: e.message
  end

  # GET /orders/:id - 注文詳細
  def show
    @order = current_user.orders.find(params[:id])
  end

  # GET /orders - 注文履歴
  def index
    @orders = current_user.orders.order(created_at: :desc)
  end

  private

  def initialize_cart
    session[:cart] ||= {}
  end
end
