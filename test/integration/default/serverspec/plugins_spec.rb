require_relative 'spec_helper'

describe file('/tmp/kitchen/cache/nagios-plugins-1.5.tar.gz') do
  it { should be_file }
end

describe command('/usr/share/icinga/libexec/check_nagios -V | grep 1.5 -ci') do
  it { should return_stdout '1' }
end