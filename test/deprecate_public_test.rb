require File.join(File.dirname(File.dirname(File.expand_path(__FILE__))), 'lib', 'deprecate_public')
require 'rubygems'
gem 'minitest'
require 'minitest/autorun'

warnings = []
(class << Kernel; self; end).module_eval do
  define_method(:warn) do |*args|
    warnings << args.first
  end
end

class DPSTest
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
