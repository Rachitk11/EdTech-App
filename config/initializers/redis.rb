
if Rails.env.test?
    require 'mock_redis'
    $redis_onlines = MockRedis.new
end