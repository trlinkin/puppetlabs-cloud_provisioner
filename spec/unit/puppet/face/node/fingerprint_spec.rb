require 'spec_helper'
require 'puppet/cloudpack'

describe Puppet::Face[:node, :current] do
  before :all do
    data = Fog::AWS::Compute::Mock.data['us-east-1'][Fog.credentials[:aws_access_key_id]]
    data[:images]['ami-12345'] = { 'imageId' => 'ami-12345' }
    data[:key_pairs]['some_keypair'] = { 'keyName' => 'some_keypair' }
  end

  before :each do
    @options = {
      :platform => 'AWS',
      :region   => 'us-east-1',
    }
  end

  describe 'option validation' do
    describe '(fingerprint)' do
      it 'should not require a platform' do
        @options.delete(:platform)
        # JJM This is absolutely not ideal, but I cannot for the life of me
        # figure out how to effectively deal with all of the create_connection
        # method calls in the option validation code.
        Puppet::CloudPack.stubs(:create_connection).with() do |options|
          raise(Exception, "#{options[:platform] == 'AWS'}")
        end
        expect { subject.fingerprint(@options) }.to raise_error Exception, 'true'
      end

      it 'should validate the platform' do
        pending "This test does not pass because there are no required options for the action.  Pending proper handling of option defaults in the Faces API."
        @options[:platform] = 'UnsupportedProvider'
        expect { subject.fingerprint(@options) }.to raise_error ArgumentError, /one of/
      end
    end

    describe '(region)' do
      it "should not require a region name" do
        @options.delete(:region)
        # JJM This is absolutely not ideal, but I cannot for the life of me
        # figure out how to effectively deal with all of the create_connection
        # method calls in the option validation code.
        Puppet::CloudPack.stubs(:create_connection).with() do |options|
          raise(Exception, "region:#{options[:region]}")
        end
        expect { subject.fingerprint(@options) }.to raise_error Exception, 'region:us-east-1'
      end

      it 'should validate the region' do
        pending "This test does not pass because there are no required options for the action.  Pending proper handling of option defaults in the Faces API."
        @options[:region] = 'mars-east-100'
        expect { subject.fingerprint(@options) }.to raise_error ArgumentError, /one of/
      end
    end

  end
end


