require 'spec_helper'

describe Sndfile::Error do

  it "inludes all info in to_s" do
    error = Sndfile::Error.new(:description => 'ABCDEF', :code => 'GHIJKL', :file => 'MNOPQR')
    error.to_s.should =~ /\bABCDEF\b/
    error.to_s.should =~ /\bGHIJKL\b/
    error.to_s.should =~ /\bMNOPQR\b/
  end

end
