require 'spec_helper'
describe 'plone' do

  context 'with defaults for all parameters' do
    it { should contain_class('plone') }
  end
end
