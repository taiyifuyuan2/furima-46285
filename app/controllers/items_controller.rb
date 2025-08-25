# frozen_string_literal: true

class ItemsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  before_action :set_item, only: %i[show edit update destroy]
  before_action :ensure_owner, only: %i[edit update destroy]
  before_action :ensure_not_sold, only: %i[edit update destroy]

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
      redirect_to root_path, notice: t('.success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @item.update(item_params)
      redirect_to item_path(@item), notice: t('.success')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy
    redirect_to root_path, notice: t('.success')
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

    redirect_to root_path, alert: t('items.edit.no_permission')
  end

  def ensure_not_sold
    return if @item.order.blank?

    redirect_to root_path, alert: '売却済みの商品です'
  end
end
