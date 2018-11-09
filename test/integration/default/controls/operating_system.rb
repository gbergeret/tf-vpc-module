control "operating_system" do
  describe "the operating system" do
    subject do
      command("cat /etc/os-release").stdout
    end

    it "is CoreOS" do
      is_expected.to match (/CoreOS/)
    end
  end
end
