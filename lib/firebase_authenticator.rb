module FirebaseAuthenticator
    # Net::HTTP用にnet/httpを読み込み
    require "net/http"
    # エラー用クラス設定
    class InvalidTokenError < StandardError; end
  
    # 定数設定
    ALG = ENV['FIREBASE_AUTH_ALG']
    KID = ENV['FIREBASE_AUTH_KID']
    PROJECT_ID = ENV['FIREBASE_PROJECT_ID']
    ISS_BASE = ENV['FIREBASE_AUTH_ISS_BASE']
  
    # idToken検証用メソッド
    def decode(token = nil)
      # JWT.decodeのオプション設定
      options = {
        algorithm: ALG,
        iss: ISS_BASE + PROJECT_ID,
        verify_iss: true,
        aud: PROJECT_ID,
        verify_aud: true,
        verify_iat: true,
      }
  
      # tokenをデコードしてpayloadを取得
      payload, _ = JWT.decode(token, nil, true, options) do |header|
        # fetch_certificatesの戻り値はハッシュなのでキーを指定
        cert = fetch_certificates[header['kid']]
        if cert.present?
          OpenSSL::X509::Certificate.new(cert).public_key
        else
          nil
        end
      end
  
      # JWT.decode でチェックされない項目のチェック
      raise InvalidTokenError.new('Invalid auth_time') unless Time.zone.at(payload['auth_time']).past?
      raise InvalidTokenError.new('Invalid sub') if payload['sub'].empty?
  
      # payloadを返す
      payload
  
    # 例外処理
    rescue JWT::DecodeError => e
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join("\n")
      raise InvalidTokenError.new(e.message)
  
    end
  
    # 証明書読み込み用メソッド
    def fetch_certificates
      res = Net::HTTP.get_response(URI(KID))
      raise 'Fetch certificates error' unless res.is_a?(Net::HTTPSuccess)
      body = JSON.parse(res.body)
    end
  
  end