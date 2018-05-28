module ApplicationHelper
  def full_title page_title = " "
    base_title = t "layouts.base_title"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def link_to_add_fields name, f, association, places
    new_object = f.object.send(association).klass.new
    field = f.fields_for(association, new_object,
      child_index: "new_#{association}") do |builder|
      render association.to_s.singularize + "_field",
        {f: builder, places: places}
    end
    link_to name, "#", class: "add_field",
      data: {association: association, field: field.gsub("\n", "")}
  end
end
