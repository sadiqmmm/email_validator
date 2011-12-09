require 'spec_helper'

class TestUser < TestModel
  validates :email, :email => true
end

class StrictUser < TestModel
  validates :email, :email => {:strict_mode => true}
end

class TestUserAllowsNil < TestModel
  validates :email, :email => {:allow_nil => true}
end

class TestUserAllowsNilFalse < TestModel
  validates :email, :email => {:allow_nil => false}
end

class TestUserWithMessage < TestModel
  validates :email_address, :email => {:message => 'is not looking very good!'}
end

describe EmailValidator do
  describe "validation" do
    context "in normal mode" do
      context "given the valid emails" do
        [
          "user@example.com",
          " user@example.com ",
          "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ@letters-in-local.org",
          "01234567890@numbers-in-local.net",
          "&'*+-./=?^_{}~@other-valid-characters-in-local.net",
          "mixed-1234-in-{+^}-local@sld.net",
          "a@single-character-in-local.org",
          "one-character-third-level@a.example.com",
          "single-character-in-sld@x.org",
          "local@dash-in-sld.com",
          "letters-in-sld@123.com",
          "one-letter-sld@x.org",
          "uncommon-tld@sld.museum",
          "uncommon-tld@sld.travel",
          "uncommon-tld@sld.mobi",
          "country-code-tld@sld.uk",
          "country-code-tld@sld.rw",
          "local@sld.newTLD",
          # "punycode-numbers-in-tld@sld.xn--3e0b707e",
          "local@sub.domains.com",
          "aaa@bbb.co.jp",
          "nigel.worthington@big.co.uk",
          "f@c.com",
          "areallylongnameaasdfasdfasdfasdf@asdfasdfasdfasdfasdf.ab.cd.ef.gh.co.ca",
        ].each do |email|
          it "#{email.inspect} should be valid" do
            TestUser.new(:email => email).should be_valid
          end
        end
      end

      context "given the invalid emails" do
        [
          "",
          " ",
          "f@s",
          "f@s.c",
          "@bar.com",
          "test@example.com@example.com",
          "test@",
          "@missing-local.org",
          "! \#$%\`|@invalid-characters-in-local.org",
          "<>@[]\`|@even-more-invalid-characters-in-local.org",
          "partially.\"quoted\"@sld.com",
          "the-local-part-is-invalid-if-it-is-longer-than-sixty-four-characters@sld.net",
          "missing-sld@.com",
#           "sld-starts-with-dashsh@-sld.com",
#           "sld-ends-with-dash@sld-.com",
          "invalid-characters-in-sld@! \"\#$%(),/;<>_[]\`|.org",
          "missing-dot-before-tld@com",
          "missing-tld@sld.",
          "missing-at-sign.net",
          "unbracketed-IP@127.0.0.1",
          "invalid-ip@127.0.0.1.26",
          "another-invalid-ip@127.0.0.256",
          "hans,peter@example.com",
          "hans(peter@example.com",
          "hans)peter@example.com",
          "IP-and-port@127.0.0.1:25",
        ].each do |email|
          it "#{email.inspect} should not be valid" do
            TestUser.new(:email => email).should_not be_valid
          end
        end
      end
    end

    context "in strict mode" do
      context "given the valid emails" do
        [
          "user@example.com",
          " user@example.com ",
          "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ@letters-in-local.org",
          "01234567890@numbers-in-local.net",
          "a@single-character-in-local.org",
          "one-character-third-level@a.example.com",
          "single-character-in-sld@x.org",
          "local@dash-in-sld.com",
          "letters-in-sld@123.com",
          "one-letter-sld@x.org",
          "uncommon-tld@sld.museum",
          "uncommon-tld@sld.travel",
          "uncommon-tld@sld.mobi",
          "country-code-tld@sld.uk",
          "country-code-tld@sld.rw",
          "local@sld.newTLD",
          # "punycode-numbers-in-tld@sld.xn--3e0b707e",
          "local@sub.domains.com",
          "aaa@bbb.co.jp",
          "nigel.worthington@big.co.uk",
          "f@c.com",
          "areallylongnameaasdfasdfasdfasdf@asdfasdfasdfasdfasdf.ab.cd.ef.gh.co.ca",
        ].each do |email|
          it "#{email.inspect} should be valid" do
            StrictUser.new(:email => email).should be_valid
          end
        end
      end

      context "given the invalid emails" do
        [
          "",
          " ",
          "f@s",
          "f@s.c",
          "@bar.com",
          "test@example.com@example.com",
          "test@",
          "@missing-local.org",
          "! \#$%\`|@invalid-characters-in-local.org",
          "<>@[]\`|@even-more-invalid-characters-in-local.org",
          "partially.\"quoted\"@sld.com",
          "the-local-part-is-invalid-if-it-is-longer-than-sixty-four-characters@sld.net",
          "missing-sld@.com",
#           "sld-starts-with-dashsh@-sld.com",
#           "sld-ends-with-dash@sld-.com",
          "invalid-characters-in-sld@! \"\#$%(),/;<>_[]\`|.org",
          "missing-dot-before-tld@com",
          "missing-tld@sld.",
          "missing-at-sign.net",
          "unbracketed-IP@127.0.0.1",
          "invalid-ip@127.0.0.1.26",
          "another-invalid-ip@127.0.0.256",
          "hans,peter@example.com",
          "hans(peter@example.com",
          "hans)peter@example.com",
          "IP-and-port@127.0.0.1:25",

          # additional entries for strict mode
          "&'*+-./=?^_{}~@other-valid-characters-in-local.net",
          "mixed-1234-in-{+^}-local@sld.net",
        ].each do |email|
          it "#{email.inspect} should not be valid" do
            StrictUser.new(:email => email).should_not be_valid
          end
        end
      end
    end
  end

  describe "error messages" do
    context "when the message is not defined" do
      subject { TestUser.new :email => 'invalidemail@' }
      before { subject.valid? }

      it "should add the default message" do
        subject.errors[:email].should include "is invalid"
      end
    end

    context "when the message is defined" do
      subject { TestUserWithMessage.new :email_address => 'invalidemail@' }
      before { subject.valid? }

      it "should add the customized message" do
        subject.errors[:email_address].should include "is not looking very good!"
      end
    end
  end

  describe "nil email" do
    it "should not be valid when :allow_nil option is missing" do
      TestUser.new(:email => nil).should_not be_valid
    end

    it "should be valid when :allow_nil options is set to true" do
      TestUserAllowsNil.new(:email => nil).should be_valid
    end

    it "should not be valid when :allow_nil option is set to false" do
      TestUserAllowsNilFalse.new(:email => nil).should_not be_valid
    end
  end
end
