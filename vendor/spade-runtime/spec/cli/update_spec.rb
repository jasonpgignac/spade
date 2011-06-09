require "spec_helper"

describe "spade update" do
  before do
    # prep the application
    goto_home
    
    FileUtils.mkdir_p (@app_path = tmp.join("update_test"))
    FileUtils.mkdir_p (@app_packages_path = @app_path.join("packages"))
    FileUtils.mkdir_p (@app_vendor_packages_path = @app_path.join("vendor/packages"))
    app_package_file_path = @app_path.join("package.json")
    File.open(app_package_file_path, 'w') do |f2|  
      f2.puts '{"name":"update_test","dependencies":{"fake_package": null}}'
    end
    cd(@app_path)
    
  end
  after do
    cd(home)
    FileUtils.rm_r @app_path
  end
  
  it "should use required packages if they are in the application's packages folder" do
    FileUtils.mkdir_p (package_path = @app_packages_path.join("fake_package"))
    package_file_path = package_path.join("package.json")
    File.open(package_file_path, 'w') do |f|
      f.puts '{"name": "fake_package"}'
    end
    spade("runtime","update", "--working=#{@app_path.to_s}")
    wait()
    "fake_package".should be_linked_to("../../packages/fake_package")
  end
  it "should use required packages if they are in the application's vendor/packages folder" do
    FileUtils.mkdir_p (package_path = @app_vendor_packages_path.join("fake_package"))
    package_file_path = package_path.join("package.json")
    File.open(package_file_path, 'w') do |f|
      f.puts '{"name": "fake_package"}'
    end
    spade("runtime","update", "--working=#{@app_path.to_s}")
    wait()
    "fake_package".should be_linked_to("../../vendor/packages/fake_package")
  end
  it "should use required packages if they are in the home folder" do
    FileUtils.mkdir_p (package_path = spade_dir.join("gems","fake_package"))
    package_file_path = package_path.join("package.json")
    File.open(package_file_path, 'w') do |f|
      f.puts '{"name": "fake_package"}'
    end
    unthreaded_spade("runtime","update", "--working=#{@app_path.to_s}")
    "fake_package".should be_linked_to(package_path)
  end
  it "should install from the network repository if it does not exist elsewhere"
  it "should raise an error if the package is in none of the locations"
  it "should not link to a package if it is the incorrect version"
  it "should install the correct version"
  it "should raise an error if the package is only available in the wrong version"
  it "should create a spade-boot.js"
  it "should record the versions in spade-boot.js"
end
