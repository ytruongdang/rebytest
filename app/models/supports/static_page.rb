class Supports::StaticPage
  def initialize
    @tours ||= Tour.available
  end

  methods = %w(newest_tours hotest_tours cheapest_tours)
  methods.each do |method|
    define_method method do
      instance_variable_set "@#{method}", @tours.send(method)
        .limit(Settings.tours.send method)
    end
  end

  define_method :popular_places do
    @popular_places = Place.popular_desc.limit Settings.tours.popular_places
  end
end
