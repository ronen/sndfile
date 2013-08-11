require 'spec_helper'

describe "Integration" do

  it "should copy a file" do
    inpath = in_path("ComputerMagic.wav")
    outpath, refpath = out_ref_paths("copy.wav")

    fin = Sndfile::File.open(inpath)
    Sndfile::File.open(outpath, :mode => :WRITE, :format => :WAV, :encoding => :PCM_16, :channels => 2, :samplerate => fin.info.samplerate) do |fout|
      while data = fin.read(12345)
        fout.write(data)
      end
      system("cmp #{outpath} #{refpath}").should be_true
    end
  end

  it "should mix two files to and write the result" do
    inpath1 = in_path("ComputerMagic.wav")
    inpath2 = in_path("Flute3.wav")
    outpath, refpath = out_ref_paths("mix.wav")

    fin1 = Sndfile::File.open(inpath1)
    fin1.info.channels.should == 2

    fin2 = Sndfile::File.open(inpath2)
    fin2.info.channels.should == 1
    fin1.info.samplerate.should == fin2.info.samplerate

    Sndfile::File.open(outpath, :mode => :WRITE, :format => :WAV, :encoding => :PCM_16, :channels => 2, :samplerate => fin1.info.samplerate) do |fout|
      while true
        a = fin1.read(10000)
        b = fin2.read(10000)
        b = b * GSLng::Matrix.from_array([[1,0]]) if b
        case
        when a.nil? && b.nil?
          break
        when a.nil?
          r = b
        when b.nil?
          r = a
        when a.frames > b.frames
          r = a
          r.view(0, 0, b.frames, 2).add! b
        when b.frames > a.frames
          r = b
          r.view(0, 0, a.frames, 2).add! a
        else
          r = a
          r.add! b
        end
        fout.write(r)
      end
      system("cmp #{outpath} #{refpath}").should be_true
    end
  end

  it "should multiply data by a scalar" do
    inpath = in_path("ComputerMagic.wav")
    outpath, refpath = out_ref_paths("half.wav")

    fin = Sndfile::File.open(inpath)
    Sndfile::File.open(outpath, :mode => :WRITE, :format => :WAV, :encoding => :PCM_16, :channels => 2, :samplerate => fin.info.samplerate) do |fout|
      while data = fin.read(10000)
        fout.write(data * 0.5)
      end
      system("cmp #{outpath} #{refpath}").should be_true
    end
  end

end
