require 'spade/dependency_installer'

module Spade
  class Remote < Repository
    include Gem::UserInteraction

    def login(email, password)
      response = raw_request :get, "api/v1/api_key" do |req|
        req.basic_auth email, password
      end

      case response
      when Net::HTTPSuccess
        creds.save(email, response.body)
        true
      else
        false
      end
    end

    def push(package)
      begin
        body = Gem.read_binary package
        Gem::Format.from_file_by_path(package)
      rescue Exception => ex
        return "There was a problem opening your package.\n#{ex.class}: #{ex.to_s}"
      end

      request :post, "api/v1/gems" do |req|
        req.body = body
        req.add_field "Content-Length", body.size
        req.add_field "Content-Type",   "application/octet-stream"
        req.add_field "Authorization",  creds.api_key
      end
    end

    def yank(package, version)
      request :delete, "api/v1/gems/yank" do |req|
        req.set_form_data 'gem_name' => package, 'version' => version
        req.add_field "Authorization", creds.api_key
      end
    end

    def unyank(package, version)
      request :put, "api/v1/gems/unyank" do |req|
        req.set_form_data 'gem_name' => package, 'version' => version
        req.add_field "Authorization", creds.api_key
      end
    end

    def add_owner(package, email)
      request :post, "api/v1/gems/#{package}/owners" do |req|
        req.set_form_data 'email' => email
        req.add_field "Authorization", creds.api_key
      end
    end

    def remove_owner(package, email)
      request :delete, "api/v1/gems/#{package}/owners" do |req|
        req.set_form_data 'email' => email
        req.add_field "Authorization", creds.api_key
      end
    end

    def list_owners(package)
      request :get, "api/v1/gems/#{package}/owners.yaml" do |req|
        req.add_field "Authorization", creds.api_key
      end
    end

    def list_packages(packages, all, prerelease)
      fetcher = Gem::SpecFetcher.fetcher
      fetcher.find_matching(dependency_for(packages), all, false, prerelease).map(&:first)
    end

    def install(package, version, prerelease)
      inst = Spade::DependencyInstaller.new(:prerelease => prerelease)
      inst.install package, Gem::Requirement.new([version])
      inst.installed_gems
    end

    private

    def raw_request(method, path, &block)
      require 'net/http'
      host = ENV['RUBYGEMS_HOST'] || Gem.host
      uri = URI.parse "#{host}/#{path}"

      request_method = Net::HTTP.const_get method.to_s.capitalize

      Gem::RemoteFetcher.fetcher.request(uri, request_method, &block)
    end

    def request(method, path, &block)
      response = raw_request(method, path, &block)
      response.body
    end
  end
end
