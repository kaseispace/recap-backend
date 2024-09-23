class OpenaiFeedbackGeneratorService
  class OpenAIError < StandardError
    attr_reader :status

    def initialize(message, status)
      super(message)
      @status = status
    end
  end

  def initialize(user_input)
    @user_input = user_input
    @client = OpenAI::Client.new
  end

  def call
    response = @client.chat(
      parameters: {
        model: ENV.fetch('OPENAI_MODEL', nil),
        messages: [{ role: 'user', content: generate_prompt(@user_input) }],
        temperature: 0.7
      }
    )

    unless response.key?('choices') && response['choices'].any?
      raise OpenAIError.new('予期しないレスポンスが返されました。', :unprocessable_entity)
    end

    response.dig('choices', 0, 'message', 'content')
  rescue Faraday::ClientError, Faraday::ServerError => e
    handle_response_error(e)
  rescue Faraday::Error
    raise OpenAIError.new('通信エラーが発生しました。', :service_unavailable)
  end

  # 例外
  def handle_response_error(error)
    status = error.response[:status]
    case status
    when 400
      raise OpenAIError.new('リクエストが不正です。入力内容を確認してください。', :bad_request)
    when 401
      raise OpenAIError.new('認証に失敗しました。管理者にお問い合わせ下さい。', :unauthorized)
    when 403..404
      raise OpenAIError.new('リソースが見つかりませんでした。URLを確認して下さい。', :not_found)
    when 408
      raise OpenAIError.new('リクエストがタイムアウトしました。しばらくしてから再試行してください。', :request_timeout)
    when 429
      raise OpenAIError.new('リクエストが上限に達しました。管理者にお問い合わせ下さい。', :too_many_requests)
    when 500..599
      raise OpenAIError.new('サーバー側で問題が発生しました。しばらくしてから再試行してください。', :internal_server_error)
    else
      raise OpenAIError.new('予期しないエラーが発生しました。', :unprocessable_entity)
    end
  end

  private

  def generate_prompt(query)
    "以下のようなチャットとの会話があります。
        これはチャットを通して授業内で学習者が振り返りを行った結果です。
        この学習者の振り返りに対して、学習のアドバイスなどを150文字以内でフィードバックしてください。

        #{query}"
  end
end
