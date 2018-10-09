unless Rails.env.test?
  Raven.configure do |config|
    config.dsn = 'https://1c1b1c9b8812475f9e9d8a7a4250c28a:754b00a522c84f1ea8ab6a5828fae9ef@sentry.io/1297688'
  end
end
