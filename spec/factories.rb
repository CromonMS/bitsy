FactoryGirl.define do

  factory :blockchain_notification, class: Bitsy::BlockchainNotification do
    value 1.2
    sequence(:transaction_hash) {|n| "transaction_hash_#{n}"}
    input_address "input_address"
    confirmations 1
    secret "secret"
  end

  factory :payment_depot, class: "Bitsy::PaymentDepot" do
    min_payment 2
    initial_tax_rate 0.5
    added_tax_rate 0.03
    owner_address "the address of the owner"
    tax_address "address where the tax money goes"
  end

  factory :payment_transaction, class: "Bitsy::PaymentTransaction" do
    payment_depot
    amount 1.345
    receiving_address 'the address that received the money'
    payment_type "receive"
    transaction_id "xx1"
  end

  factory :bit_wallet, :class => OpenStruct do
  end

  factory :bit_wallet_account, :class => OpenStruct do
    sequence(:name) {|n| n.to_s}
    addresses do |account|
      [FactoryGirl.build(:bit_wallet_address, account: account)]
    end
  end

  factory :bit_wallet_address, :class => OpenStruct do
    account { FactoryGirl.build(:bit_wallet_account) }
    sequence(:address) {|n| "address_#{n+1000}"}
  end

  factory :bit_wallet_transaction, :class => OpenStruct do
    account { FactoryGirl.build(:bit_wallet_account) }
    sequence(:id) {|n| "longhash_#{n}"}
    sequence(:address_str) {|n| "address_#{n}"}
    amount 1.22
    category 'receive'
    confirmations 0
    occurred_at 1.minute.ago
    received_at 1.minute.ago
  end

end
