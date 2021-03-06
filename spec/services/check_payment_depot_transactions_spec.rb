require "spec_helper"

module Bitsy
  describe CheckPaymentDepotTransactions, ".execute" do

    let(:latest_block) { build(:blockchain_latest_block) }
    let(:payment_depot) { build_stubbed(:payment_depot, address: "address") }
    let(:blockchain_transaction_1) { build(:blockchain_transaction) }
    let(:blockchain_transaction_2) { build(:blockchain_transaction) }
    let(:blockchain_transactions) do
      [blockchain_transaction_1, blockchain_transaction_2]
    end
    let(:blockchain_address) do
      build(:blockchain_address, address: "address")
    end

    before do
      expect(Blockchain).to receive(:get_address).with("address").
        and_return(blockchain_address)
      expect(blockchain_address).to receive(:transactions).
        and_return(blockchain_transactions)
    end

    it "checks the transactions of the payment depot and resets the check count" do
      blockchain_transactions.each do |tx|
        expect(ProcessBlockchainBlockexplorerTransaction).
          to receive(:execute).with(
            payment_depot: payment_depot,
            latest_block: latest_block,
            blockchain_transaction: tx,
          )
      end

      expect(payment_depot).to receive(:reset_checked_at!)

      described_class.execute(
        latest_block: latest_block,
        payment_depot: payment_depot,
      )
    end

  end
end
