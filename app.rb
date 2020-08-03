class App

  ALL_FORMATS = ['year', 'month', 'day', 'hour', 'min', 'sec']

  def call(env)
    @path = env['PATH_INFO']
    @query = env['QUERY_STRING']
    [status, headers, body]
  end

  private

  def status
    200
  end

  def headers
    {'Content-Type' => 'text/plain'}
  end

  def body
    format = @query.gsub('format=', '').chomp('%').split('%2C')

    time = Time.now
    # Хеш с текущим временем
    time_hash = {}

    ALL_FORMATS.each do |form|
      time_hash[form] = time.send(form)
    end

    time_output = []

    format.each do |form|
        time_output << time_hash[form] if time_hash.keys.include?(form)
    end

    [time_output.join('-')]
  end
end

# start_with?("format=")
# /time?format=year%2Cmonth%2Cday
# # "QUERY_STRING"=>"text=1:"
# # "PATH_INFO"=>"/time:"
