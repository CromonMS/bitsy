require "spec_helper"

describe "Payment depot management", vcr: {record: :once} do
  let(:wallet) { Bitsy.bit_wallet }
  let(:owner_address) { "owner_address" }
  let(:taxer_address) { "taxer_address" }

  it "creates a payment depot to monitor payments" do
    post bitsy.v1_payment_depots_path(payment_depot: {
      min_payment: 2.0,
      initial_tax_rate: 0.8,
      added_tax_rate: 0.1,
      owner_address: owner_address,
      tax_address: taxer_address,
    })

    json_response = JSON.parse(response.body).with_indifferent_access
    payment_depot = Bitsy::PaymentDepot.find(json_response[:payment_depot][:id])

    # Buyer pays
    get bitsy.v1_blockchain_notifications_path(
      value: 200_000_000.0,
      transaction_hash: "transaction_hash",
      input_address: payment_depot.address,
      confirmations: 0,
      secret: Bitsy.config.blockchain_secrets.sample,
      test: false,
    )

    expect(Bitsy::BlockchainNotification.count).to be > 0

    tx_fee_satoshi = (Bitsy.config.transaction_fee * 100_000_000).to_i
    total_payment_amount = 200_000_000 - tx_fee_satoshi
    expected_tax_fee = ((16.0 / 20.0) * total_payment_amount).to_i
    expected_owner_fee = ((4.0 / 20.0) * total_payment_amount).to_i

    # Since blockchain has no test account, we simulate it instead of
    # fully running the ForwardJob
    expected_send_many_hash = {
      "taxer_address" => expected_tax_fee,
      "owner_address" => expected_owner_fee,
    }
    payment_response = build(:blockchain_payment_response, tx_hash: "tx_hash")
    expect_any_instance_of(Blockchain::Wallet).to receive(:send_many).
      with(expected_send_many_hash, fee: tx_fee_satoshi).
      and_return(payment_response)

    resulting_ctx = Bitsy::ForwardJob.new.perform
    expect(resulting_ctx.forwarding_transaction_id).
      to eq payment_response.tx_hash
    expect(Bitsy::PaymentTransaction.all.pluck(:forwarding_transaction_id)).
      to eq [payment_response.tx_hash]
    expect(payment_depot.reload.total_received_amount).to eq 2.0
  end

end
