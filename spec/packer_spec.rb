require "spec_helper"

describe Spade::Packer, "transforming" do
  let(:email) { "user@example.com" }

  before do
    cd(home)
  end

  subject do
    packer = Spade::Packer.new(fixtures("package.json"), email)
    packer.transform
  end

  it "transforms the name" do
    subject.name.should == "coffee-script"
  end

  it "transforms the version" do
    subject.version.should == Gem::Version.new("1.0.1.pre")
  end

  it "transforms the author" do
    subject.authors.should == ["Jeremy Ashkenas"]
  end

  it "transforms the email" do
    subject.email.should == email
  end

  it "transforms the homepage" do
    subject.homepage.should == "http://github.com/jashkenas/coffee-script"
  end

  it "transforms the description" do
    subject.description.should == "Unfancy JavaScript"
  end

  it "packs metadata into requirements" do
    metadata = JSON.parse(subject.requirements.first)
    metadata["keywords"].should == %w[javascript language coffeescript compiler]
    metadata["licenses"].should == [
      {"type" => "MIT",
       "url"  => "http://github.com/jashkenas/coffee-script/raw/master/LICENSE"}
    ]
    metadata["engines"].should == {"node" => ">=0.2.5"}
    metadata["main"].should == "./lib/coffee-script"
    metadata["bin"].should == {"coffee" => "./bin/coffee", "cake" => "./bin/cake"}
  end

  def expand_sort(files)
    files.sort.map { |f| File.expand_path(f) }
  end

  it "expands paths from the directories" do
    others     = ["lib/coffee.png", "qunit/test.log"]
    files      = ["bin/coffee", "bin/cake", "lib/coffee.js", "lib/coffee/base.js", "lib/coffee/mocha/chai.js"]
    test_files = ["qunit/test.js", "qunit/coffee/test.js"]

    FileUtils.mkdir_p(["bin/", "lib/coffee/", "lib/coffee/mocha", "qunit/", "qunit/coffee"])
    FileUtils.touch(files + test_files + others)

    expand_sort(subject.files).should == expand_sort(files + test_files)
    expand_sort(subject.test_files).should == expand_sort(test_files)
  end
end
