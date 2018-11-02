control 'internet_access' do
  describe command("curl -I http://www.google.com") do
    its('stdout') { should match (/200 OK/) }
  end

  describe command("curl -I https://www.google.com") do
    its('stdout') { should match (/200 OK/) }
  end
end
