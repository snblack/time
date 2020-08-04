class App

    ALL_FORMATS = ['year', 'month', 'day', 'hour', 'min', 'sec']

  def call(env)
    @path = env['PATH_INFO']
    @query = env['QUERY_STRING']

    [status, headers, body]
  end

  private

  def status
    if false_path?
      404
    elsif false_format?
      400
    else
      200
    end
  end

  def false_path?
    true if @path != '/time'
  end

  def false_format?
    check_formats

    true if !@format_error.empty?
  end

  def check_formats
    format = @query.gsub('format=', '').chomp('%').split('%2C')

    time = Time.now
    time_hash = {}

    ALL_FORMATS.each do |form|
      time_hash[form] = time.send(form)
    end

    @time_output = []
    @format_error = []

    format.each do |form|
      if time_hash.keys.include?(form)
        @time_output << time_hash[form]
      else
        @format_error << form
      end
    end
  end

  def headers
    {'Content-Type' => 'text/plain'}
  end

  def body
    if @format_error.any?
      ["Unknown time format [#{@format_error.join(',')}]"]
    else
      [@time_output.join('-')]
    end
  end
end
