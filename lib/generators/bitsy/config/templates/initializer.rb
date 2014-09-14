Bitsy.load_config Rails.root.join("config", "bitsy.yml")

Bitsy.configure do |c|
  # How much of a transaction fee to pay to the network
  c.transaction_fee = 0.0001

  # This setting multiplied by the transaction fee is how much bitcoin the
  # system will accumulate before forwarding money
  c.transaction_fee_threshold_multiplier = 200

  # How many confirmations are needed to consider a transaction as complete
  c.safe_confirmation_threshold = 0

  # The name where all money is pooled before sending out. You will likely not
  # need to change this value. Note that blockchain.info only accepts master
  # account names between 0 and 255 characters.
  c.master_account_name = "master"
end
