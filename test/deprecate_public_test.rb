require File.join(File.dirname(File.dirname(File.expand_path(__FILE__))), 'lib', 'deprecate_public')
require 'rubygems'
ENV['MT_NO_PLUGINS'] = '1' # Work around stupid autoloading of plugins
gem 'minitest'
require 'minitest/global_expectations/autorun'

warnings = []
(class << Kernel; self; end).module_eval do
  define_method(:warn) do |*args|
    warnings << if args.last == {:uplevel => 1}
      args.first
    else
      args.first.sub(/\A.+warning: (.+)\z/, '\1')
    end
  end
end

class DPSTest
  if RUBY_VERSION >= '2.6'
    PUB = 1

    DEPPUB = 2
    deprecate_public_constant :DEPPUB

    PRIV = 3
    private_constant :PRIV

    DEPPRIV = 4
    private_constant :DEPPRIV
    deprecate_public_constant :DEPPRIV

    DEPPRIV2 = 5
    private_constant :DEPPRIV2
    deprecate_public_constant :DEPPRIV2, "custom warning for DEPPRIV2"
  end

  def pub; 1 end
  def dep_pub; 8 end
  deprecate_public(:dep_pub)

  def test_prot(other)
    other.prot
  end
  def test_dep_prot(other)
    other.dep_prot
  end

  protected

  def prot; 2 end
  def dep_prot; 9 end
  deprecate_public(:dep_prot)

  private

  def priv; 3 end
  def dep_priv; 4 end
  deprecate_public(:dep_priv)

  def dep_priv1; 5 end
  def dep_priv2; 6 end
  deprecate_public([:dep_priv1, :dep_priv2])

  def dep_priv_msg; 7 end
  deprecate_public(:dep_priv_msg, "custom warning for dep_priv_msg")
end

class DPSTest2
  def test_dep_prot(other)
    other.dep_prot
  end
end

describe "Module#deprecate_public" do
  before do
    @obj = DPSTest.new
    warnings.clear
  end

  after do
    warnings.must_equal []
  end

  it "should not warn for methods if deprecate_public is not used and access should be allowed" do
    @obj.pub.must_equal 1
    @obj.test_prot(DPSTest.new).must_equal 2
    @obj.instance_exec do
      prot.must_equal 2
      priv.must_equal 3
    end
  end

  it "should raise NoMethodError for private/protected method calls if deprecate_public is not used" do
    proc{@obj.prot}.must_raise NoMethodError
    proc{@obj.priv}.must_raise NoMethodError
  end

  it "should not warn if methods are public and deprecate_public is used" do
    @obj.dep_pub.must_equal 8
  end

  it "should not warn if methods are protected and deprecate_public is used and access should be allowed" do
    @obj.test_dep_prot(DPSTest.new).must_equal 9
  end

  it "should warn if methods are private and deprecate_public is used" do
    @obj.dep_priv.must_equal 4
    @obj.dep_priv1.must_equal 5
    @obj.dep_priv2.must_equal 6
    @obj.dep_priv_msg.must_equal 7
    warnings.must_equal [
      "calling DPSTest#dep_priv using deprecated public interface",
      "calling DPSTest#dep_priv1 using deprecated public interface",
      "calling DPSTest#dep_priv2 using deprecated public interface",
      "custom warning for dep_priv_msg"
    ]
    warnings.clear
  end

  it "should warn if methods are protected and deprecate_public is used" do
    DPSTest2.new.test_dep_prot(@obj).must_equal 9
    warnings.must_equal ["calling DPSTest#dep_prot using deprecated public interface"]
    warnings.clear
  end

  it "should raise NoMethodError if the method is not defined" do
    class << @obj
      undef :dep_priv
    end
    proc{@obj.dep_priv}.must_raise NoMethodError
  end
end

if RUBY_VERSION >= '2.6'
describe "Module#deprecate_public_constant" do
  before do
    warnings.clear
  end
  after do
    warnings.must_equal []
  end

  it "should not warn for constant if deprecate_public_constant is not used and access should be allowed" do
    DPSTest::PUB.must_equal 1
    class DPSTest
      PRIV.must_equal 3
    end
  end

  it "should raise NameError for private constants if deprecate_public_constant is not used" do
    proc{DPSTest::PRIV}.must_raise NameError
  end

  it "should not warn if constants are public and deprecate_public_constant is used" do
    DPSTest::DEPPUB.must_equal 2
  end

  it "should warn if constants are private and deprecate_public_constant is used" do
    DPSTest::DEPPRIV.must_equal 4
    DPSTest::DEPPRIV2.must_equal 5
    warnings.must_equal [
      "accessing DPSTest::DEPPRIV using deprecated public interface",
      "custom warning for DEPPRIV2"
    ]
    warnings.clear
  end

  it "should raise NameError if the constant is not defined" do
    c = Class.new
    c.deprecate_public_constant :PUB
    proc{c::PUB}.must_raise NameError
  end
end
end

if RUBY_VERSION >= '3.0'
module DPSTestMod
end
class DPSTestClass
  include DPSTestMod
end

module DPSTestMod
  if RUBY_VERSION >= '2.6'
    PUB = 1

    DEPPUB = 2
    deprecate_public_constant :DEPPUB

    PRIV = 3
    private_constant :PRIV

    DEPPRIV = 4
    private_constant :DEPPRIV
    deprecate_public_constant :DEPPRIV

    DEPPRIV2 = 5
    private_constant :DEPPRIV2
    deprecate_public_constant :DEPPRIV2, "custom warning for DEPPRIV2"
  end

  def pub; 1 end
  def dep_pub; 8 end
  deprecate_public(:dep_pub)

  def test_prot(other)
    other.prot
  end
  def test_dep_prot(other)
    other.dep_prot
  end

  protected

  def prot; 2 end
  def dep_prot; 9 end
  deprecate_public(:dep_prot)

  private

  def priv; 3 end
  def dep_priv; 4 end
  deprecate_public(:dep_priv)

  def dep_priv1; 5 end
  def dep_priv2; 6 end
  deprecate_public([:dep_priv1, :dep_priv2])

  def dep_priv_msg; 7 end
  deprecate_public(:dep_priv_msg, "custom warning for dep_priv_msg")
end

class DPSTestClass
  include DPSTestMod
end

describe "Module#deprecate_public" do
  before do
    @obj = DPSTestClass.new
    warnings.clear
  end

  after do
    warnings.must_equal []
  end

  it "should not warn for methods if deprecate_public is not used and access should be allowed" do
    @obj.pub.must_equal 1
    @obj.test_prot(DPSTestClass.new).must_equal 2
    @obj.instance_exec do
      prot.must_equal 2
      priv.must_equal 3
    end
  end

  it "should raise NoMethodError for private/protected method calls if deprecate_public is not used" do
    proc{@obj.prot}.must_raise NoMethodError
    proc{@obj.priv}.must_raise NoMethodError
  end

  it "should not warn if methods are public and deprecate_public is used" do
    @obj.dep_pub.must_equal 8
  end

  it "should not warn if methods are protected and deprecate_public is used and access should be allowed" do
    @obj.test_dep_prot(DPSTestClass.new).must_equal 9
  end

  it "should warn if methods are private and deprecate_public is used" do
    @obj.dep_priv.must_equal 4
    @obj.dep_priv1.must_equal 5
    @obj.dep_priv2.must_equal 6
    @obj.dep_priv_msg.must_equal 7
    warnings.must_equal [
      "calling DPSTestMod#dep_priv using deprecated public interface",
      "calling DPSTestMod#dep_priv1 using deprecated public interface",
      "calling DPSTestMod#dep_priv2 using deprecated public interface",
      "custom warning for dep_priv_msg"
    ]
    warnings.clear
  end

  it "should warn if methods are protected and deprecate_public is used" do
    DPSTest2.new.test_dep_prot(@obj).must_equal 9
    warnings.must_equal ["calling DPSTestMod#dep_prot using deprecated public interface"]
    warnings.clear
  end

  it "should raise NoMethodError if the method is not defined" do
    class << @obj
      undef :dep_priv
    end
    proc{@obj.dep_priv}.must_raise NoMethodError
  end
end
end
