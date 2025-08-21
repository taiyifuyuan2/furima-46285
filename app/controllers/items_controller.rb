# frozen_string_literal: true

class ItemsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update]
  before_action :set_item, only: %i[show edit update]
  before_action :ensure_owner, only: %i[edit update]

  def index
    @items = Item.order(created_at: :desc)
  end

  def show
    Rails.logger.info "商品詳細ページにアクセス: Item ID: #{@item.id}, 名前: #{@item.name}"
  end

  def new
    @item = Item.new
  end

  def edit; end

  def create
    @item = current_user.items.build(item_params)

    if @item.save
      redirect_to root_path, notice: '商品を出品しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @item.update(item_params)
      redirect_to item_path(@item), notice: '商品情報を更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :category_id, :item_condition_id,
                                 :shipping_fee_burden_id, :prefecture_id, :shipping_day_id, :price, :image)
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def ensure_owner
    return if @item.user_id == current_user.id

    redirect_to root_path, alert: '商品の編集権限がありません'
  end
end
