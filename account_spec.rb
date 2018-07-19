require "rspec"
require "rspec/given"

require_relative "account"

describe Account do
  Given(:acct_number){"1234567890"}
  Given(:startingAmt){50}
  Given(:acct){Account.new(acct_number, startingAmt)}

  describe "#initialize" do
    context "take 2 arguments at beginning" do
      Then {expect(acct).to be_a_kind_of(Account)}     
    end

    context "take 1 argument at beginning" do
      Then {expect(Account.new(acct_number)).to be_a_kind_of(Account)}     
    end
    
    context "take no argument" do
      Then {expect{Account.new}.to raise_error(ArgumentError)}
    end

    context "wrong account number length" do
      Then {expect{Account.new("123")}.to raise_error(InvalidAccountNumberError)}
    end

    context "account number is digit" do
      Then {expect{Account.new("abc")}.to raise_error(InvalidAccountNumberError)}
    end

    context "account number is string" do
      Then {expect{Account.new(123)}.to raise_error(NoMethodError)}
    end
  end

  describe "#transactions" do
    context "should store all transactions" do
      Then {expect(acct.transactions).to be_a_kind_of(Array)}  
    end

    context "return correct starting amount" do
      Then {acct.transactions[0] === 50}
    end
  end

  describe "#balance" do
    context "return the balance" do
      Then {acct.balance === 50}
    end
  end

  describe "#account_number" do
    context "hide the account number" do
      Then {acct.acct_number === "******7890"}
    end
  end

  describe "deposit!" do
    context "cannot be negative amount" do
      Then {expect{acct.deposit!(-1)}.to raise_error(NegativeDepositError)}
    end

    context "balance cannot be negative" do
      When (:invalidStartingAmt) {Account.new(acct_number, -50)}
      Then {expect{invalidStartingAmt.deposit!(30)}.to raise_error(OverdraftError)}
    end

    context "transactions increased" do
      When {acct.deposit!(30)}
      Then {acct.transactions.size === 2}
    end

    context "returns the balance" do
      Then {acct.deposit!(30) === 80}
    end
  end

  describe "#withdraw!" do
    context "amount can be negative" do
      Then {expect{acct.withdraw!(-30)}.not_to raise_error}
    end

    context "amount can be positive" do
      Then {expect{acct.withdraw!(30)}.not_to raise_error}
    end

    context "balance cannot be negative" do
      Then {expect{acct.withdraw!(60)}.to raise_error(OverdraftError)}
    end

    context "transactions increased" do
      When {acct.withdraw!(30)}
      Then {acct.transactions.size === 2}
    end

    context "returns the balance" do
      Then {acct.withdraw!(30) === 20}
    end
  end
end