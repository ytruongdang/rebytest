module PlacesHelper
  def places_tree_for places
    places.map do |place, nested_places|
      html = ""
      if place.present?
        html << content_tag(:tr, render(place),
          class: place.root? ? "" : "panel-collapse collapse
          place-#{place.parent_id}") << places_tree_for(nested_places)
      end
    end.join.html_safe
  end
end
