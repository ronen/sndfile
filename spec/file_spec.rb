require 'spec_helper'

describe Sndfile::File do

  it "File.info returns correct file info" do
    info = Sndfile::File.info(INPUTS_DIR + "ComputerMagic.wav")
    info.format.should == :WAV
    info.encoding.should == :PCM_16
    info.endian.should == :FILE
    info.frames.should == 223451
    info.samplerate.should == 44100
    info.channels.should == 2
  end

  it "File#info returns correct info structure" do
    file = INPUTS_DIR + "ComputerMagic.wav"
    info = Sndfile::File.info(file)
    Sndfile::File.open(file) do |f|
      f.info.should == info
    end
  end

  it "deprecates info methods" do
    Sndfile::File.any_instance.should_receive(:warn).with(/DEPRECATION/).exactly(6).times
    Sndfile::File.open(INPUTS_DIR + "ComputerMagic.wav") do |f|
      f.format.should == :WAV
      f.encoding.should == :PCM_16
      f.endian.should == :FILE
      f.frames.should == 223451
      f.samplerate.should == 44100
      f.channels.should == 2
    end
  end

  it "raises an error when it can't open the file" do
    expect { Sndfile::File.open("/no/such/file") }.to raise_error Sndfile::Error
  end

end
