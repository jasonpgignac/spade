RSpec::Matchers.define :be_linked_to do |package_path|
  include SpecHelpers
  match do |package_name|
    package_link_path = tmp.join("update_test",".spade","packages",package_name) 
    File.readlink(package_link_path).to_s == package_path.to_s
  end
  failure_message_for_should do |package_name|
    package_link_path = tmp.join("update_test",".spade","packages",package_name)
    "expected that #{package_name} would be linked to #{package_path}, but is linked to #{File.readlink(package_link_path)}"
  end
end

