class CreateEffectiveOrders < ActiveRecord::Migration[4.2]
  def self.up
    create_table :orders do |t|
      t.integer   :user_id
      t.string    :purchase_state
      t.datetime  :purchased_at

      t.text      :note
      t.text      :note_to_buyer
      t.text      :note_internal

      t.text      :payment

      t.string    :payment_provider
      t.string    :payment_card

      t.decimal   :tax_rate, :precision => 6, :scale => 3

      t.integer   :subtotal
      t.integer   :tax
      t.integer   :total

      t.timestamps
    end

    add_index :orders, :user_id


    create_table :order_items do |t|
      t.integer   :order_id
      t.integer   :seller_id
      t.string    :purchasable_type
      t.integer   :purchasable_id

      t.string    :title
      t.integer   :quantity
      t.integer   :price, :default => 0
      t.boolean   :tax_exempt

      t.timestamps
    end

    add_index :order_items, :order_id
    add_index :order_items, :purchasable_id
    add_index :order_items, [:purchasable_type, :purchasable_id]


    create_table :carts do |t|
      t.integer   :user_id
      t.timestamps
    end

    add_index :carts, :user_id

    create_table :cart_items do |t|
      t.integer   :cart_id
      t.string    :purchasable_type
      t.integer   :purchasable_id

      t.integer   :quantity

      t.timestamps
    end

    add_index :cart_items, :cart_id
    add_index :cart_items, :purchasable_id
    add_index :cart_items, [:purchasable_type, :purchasable_id]

    create_table :customers do |t|
      t.integer   :user_id
      t.string    :stripe_customer_id
      t.string    :stripe_active_card
      t.string    :stripe_connect_access_token

      t.timestamps
    end

    add_index :customers, :user_id

    create_table :subscriptions do |t|
      t.integer   :customer_id
      t.string    :stripe_plan_id
      t.string    :stripe_subscription_id
      t.string    :stripe_coupon_id
      t.string    :title
      t.integer   :price, :default => 0

      t.timestamps
    end

    add_index :subscriptions, :customer_id
    add_index :subscriptions, :stripe_subscription_id

    create_table :products do |t|
      t.string    :title
      t.integer   :price, :default => 0
      t.boolean   :tax_exempt, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :orders
    drop_table :order_items
    drop_table :carts
    drop_table :cart_items
    drop_table :customers
    drop_table :subscriptions
    drop_table :products
  end
end
