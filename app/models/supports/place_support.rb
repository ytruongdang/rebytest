class Supports::PlaceSupport
  def initialize params
    @parent_type = {region: nil, city: :region, place: :city}
    @place_type = params[:place_type] ? params[:place_type].to_sym : :region
  end

  def place_types
    @place_types = Place.place_types.map {|key, value|
      [I18n.t("admin.places.types.#{key}"), key]}
  end

  def place_type
    @place_type
  end

  def parent_places
    Place.where place_type: @parent_type[@place_type]
  end
end
