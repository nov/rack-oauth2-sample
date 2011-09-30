class Auth::Facebook < ActiveRecord::Base
  belongs_to :account

  def profile
    @profile ||= FbGraph::User.me(self.access_token).fetch
  end

  class << self
    def config
      @config ||= if ENV['fb_client_id'] && ENV['fb_client_secret']
        {
          :client_id     => ENV['fb_client_id'],
          :client_secret => ENV['fb_client_secret']
        }
      else
        YAML.load_file("#{Rails.root}/config/facebook.yml")[Rails.env].symbolize_keys
      end
    rescue Errno::ENOENT => e
      raise StandardError.new("config/facebook.yml could not be loaded.")
    end

    def auth
      FbGraph::Auth.new config[:client_id], config[:client_secret]
    end

    def authenticate(cookies)
      _auth_ = auth.from_cookie(cookies)
      fb_user = find_or_initialize_by_identifier _auth_.user.identifier
      fb_user.access_token = _auth_.access_token.access_token
      fb_user.save!
      fb_user.account || Account.create!(facebook: connect)
    end
  end
end
