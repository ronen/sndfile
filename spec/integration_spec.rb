require 'spec_helper'
require 'tmpdir'
require 'narray'

describe "Integration" do

  it "should copy a file" do
    inpath = in_path("ComputerMagic.wav")
    outpath, refpath = out_ref_paths("copy.wav")

    fin = Sndfile::File.open(inpath)
    Sndfile::File.open(outpath, :mode => :WRITE, :format => :WAV, :encoding => :PCM_16, :channels => 2, :samplerate => fin.samplerate) do |fout|
      while data = fin.read(10000)
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
    fin1.channels.should == 2

    fin2 = Sndfile::File.open(inpath2)
    fin2.channels.should == 1
    fin1.samplerate.should == fin2.samplerate

    Sndfile::File.open(outpath, :mode => :WRITE, :format => :WAV, :encoding => :PCM_16, :channels => 2, :samplerate => fin1.samplerate) do |fout|
      while true
        a = fin1.read(10000)
        b = fin2.read(10000)
        b = b.each_with_object(0).to_a.flatten if b
        case
        when a.nil? && b.nil?
          break
        when a.nil?
          r = b
        when b.nil?
          r = a
        else
          r = a.zip(b).map{|ai, bi| (ai||0) + (bi||0)}
        end
        fout.write(r.flatten)
      end
      system("cmp #{outpath} #{refpath}").should be_true
    end
  end

  it "should read & write integers" do
    inpath = in_path("ComputerMagic.wav")
    outpath, refpath = out_ref_paths("halfint.wav")

    fin = Sndfile::File.open(inpath)
    Sndfile::File.open(outpath, :mode => :WRITE, :format => :WAV, :encoding => :PCM_16, :channels => 2, :samplerate => fin.samplerate) do |fout|
      while data = fin.read(10000, :type => :int)
        fout.write(data.map{|x| x >> 1})
      end
      system("cmp #{outpath} #{refpath}").should be_true
    end
  end


end
