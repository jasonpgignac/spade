require "spec_helper"

describe "spade install" do
  before do
    cd(home)
    env["HOME"] = home.to_s
    env["RUBYGEMS_HOST"] = "http://localhost:9292"
    start_fake(FakeGemServer.new)
  end

  it "installs a valid gem" do
    spade "install", "rake"

    stdout.read.should include("Successfully installed rake-0.8.7")

    "rake-0.8.7".should be_fetched
    "rake-0.8.7".should be_unpacked
  end

  it "installs a multiple gems" do
    spade "install", "rake", "builder"

    output = stdout.read

    %w[builder-3.0.0 rake-0.8.7].each do |pkg|
      output.should include("Successfully installed #{pkg}")
      pkg.should be_fetched
      pkg.should be_unpacked
    end
  end

  it "installs valid gems while ignoring invalid ones" do
    spade "install", "rake", "fake"

    output = stdout.read
    output.should include("Can't find package fake")
    output.should include("Successfully installed rake-0.8.7")

    "rake-0.8.7".should be_fetched
    "rake-0.8.7".should be_unpacked
    "fake-0".should_not be_fetched
    "fake-0".should_not be_unpacked
  end

  it "fails when installing an invalid gem" do
    spade "install", "fake"

    stdout.read.should include("Can't find package fake")
    "rake-0.8.7".should_not be_fetched
    "rake-0.8.7".should_not be_unpacked
    "fake-0".should_not be_fetched
    "fake-0".should_not be_unpacked
  end

  it "fails if spade can't write to the spade directory" do
    FileUtils.mkdir_p home(".spade")
    FileUtils.chmod 0555, home(".spade")

    spade "install", "rake"

    stdout.read.should include("You don't have write permissions")

    "rake-0.8.7".should_not be_fetched
    "rake-0.8.7".should_not be_unpacked
  end

  it "installs gems with a different version" do
    spade "install", "rake", "-v", "0.8.6"

    stdout.read.should include("Successfully installed rake-0.8.6")

    "rake-0.8.7".should_not be_fetched
    "rake-0.8.7".should_not be_unpacked
    "rake-0.8.6".should be_fetched
    "rake-0.8.6".should be_unpacked
  end
end
