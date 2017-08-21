control 'internet_access' do
  describe command("curl -I http://www.google.com") do
    its('stdout') { should match (/302 Found/) }
  end

  describe command("curl -I https://www.google.com") do
    its('stdout') { should match (/302 Found/) }
  end
end
