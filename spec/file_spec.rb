require 'spec_helper'

describe Sndfile do

  it "should return correct file info" do
    Sndfile::File.open(INPUTS_DIR + "ComputerMagic.wav") do |f|
      f.format.should == :WAV
      f.encoding.should == :PCM_16
      f.endian.should == :FILE
      f.frames.should == 223451
      f.samplerate.should == 44100
      f.channels.should == 2
    end
  end

  it "should raise an error when it can't open the file" do
    expect { Sndfile::File.open("/no/such/file") }.to raise_error Sndfile::Error
  end

end
