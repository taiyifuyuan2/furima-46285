# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item
  before_action :ensure_not_owner
  before_action :ensure_not_sold

  def index
    @purchase_form = PurchaseForm.new
  end

  def create
    @purchase_form = PurchaseForm.new(purchase_params)

    if @purchase_form.save(current_user, @item)
      redirect_to root_path, notice: '商品を購入しました'
    else
      render :index, status: :unprocessable_entity
    end
  end

  private

  def purchase_params
    params.require(:purchase_form).permit(:postal_code, :prefecture_id, :city, :street_address, :building_name,
                                          :phone_number, :token)
  end

  def set_item
    @item = Item.find(params[:item_id])
  end

  def ensure_not_owner
    return unless @item.user_id == current_user.id

    redirect_to root_path, alert: '自身が出品した商品は購入できません'
  end

  def ensure_not_sold
    return if @item.order.blank?

    redirect_to root_path, alert: '売却済みの商品です'
  end
end
