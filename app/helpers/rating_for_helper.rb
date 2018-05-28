module RatingForHelper
  def rating_for rateable_obj, dimension = nil, options = {}
    cached_average = rateable_obj.average dimension
    avg = cached_average ? cached_average.avg : Settings.rates.min_star

    star = options[:star] || Settings.rates.max_star
    enable_half = options[:enable_half] || false
    half_show = options[:half_show] || true
    star_path = options[:star_path] || ""
    star_on = options[:star_on] || asset_path("star-on.png")
    star_off = options[:star_off] || asset_path("star-off.png")
    star_half = options[:star_half] || asset_path("star-half.png")
    cancel = options[:cancel] || false
    cancel_place = options[:cancel_place] || t("ratyrate.left")
    cancel_hint = options[:cancel_hint] || t("ratyrate.cancel_hint")
    cancel_on = options[:cancel_on] || asset_path("cancel-on.png")
    cancel_off = options[:cancel_off] || asset_path("cancel-off.png")
    noRatedMsg = options[:noRatedMsg] || t("ratyrate.noRateMsg")
    space = options[:space] || false
    single = options[:single] || false
    target = options[:target] || ""
    targetText = options[:targetText] || ""
    targetType = options[:targetType] || t("ratyrate.hint")
    targetFormat = options[:targetFormat] || t("ratyrate.targetFormat")
    targetScore = options[:targetScore] || ""

    disable_after_rate = options[:disable_after_rate] || true

    if options[:readonly]
      readonly = options[:readonly]
    elsif disable_after_rate
      readonly = !rateable_obj.can_rate?(current_user, dimension)
    else
      readonly = false
    end

    if options[:imdb_avg] && readonly
      content_tag :div, "",
        style: "background-image:url(/assets/mid-star.png);width:61px;height:57px;margin-top:10px;" do
          content_tag :p, avg,
            style: "position:relative;font-size:.8rem;text-align:center;line-height:60px;"
      end
    else
      content_tag :span, "", class: "star", data: {dimension: dimension,
        rating: avg, id: rateable_obj.id, classname: rateable_obj.class.name,
        disable_after_rate: disable_after_rate, readonly: readonly,
        enable_half: enable_half, half_show: half_show, star_count: star,
        star_path: star_path, star_on: star_on, star_off: star_off,
        star_half: star_half, cancel: cancel, cancel_place: cancel_place,
        cancel_hint: cancel_hint, cancel_on: cancel_on, cancel_off: cancel_off,
        no_rated_message: noRatedMsg, space: space, single: single,
        target: target, target_text: targetText, target_type: targetType,
        target_format: targetFormat, target_score: targetScore}
    end
  end

  def imdb_style_rating_for rateable_obj, user, options = {}
    overall_avg = rateable_obj.overall_avg user

    content_tag :span, "",
      style: "background-image:url(/assets/big-star.png);width:81px;height:81px;margin-top:10px;" do
        content_tag :p, overall_avg,
          style: "position:relative;line-height:85px;text-align:center;"
    end
  end

  def rating_for_user rateable_obj, rating_user, dimension = nil, options = {}
    @object = rateable_obj
    @user = rating_user
    @rating = Rate.find_by rater: @user, rateable: @object,
      dimension: dimension
    stars = @rating ? @rating.stars : Settings.rates.min_star

    star = options[:star] || Settings.rates.max_star
    enable_half = options[:enable_half] || false
    half_show = options[:half_show] || true
    star_path = options[:star_path] || ""
    star_on = options[:star_on] || asset_path("star-on.png")
    star_off = options[:star_off] || asset_path("star-off.png")
    star_half = options[:star_half] || asset_path("star-half.png")
    cancel = options[:cancel] || false
    cancel_place = options[:cancel_place] || t("ratyrate.left")
    cancel_hint = options[:cancel_hint] || t("ratyrate.cancel_hint")
    cancel_on = options[:cancel_on] || asset_path("cancel-on.png")
    cancel_off = options[:cancel_off] || asset_path("cancel-off.png")
    noRatedMsg = options[:noRatedMsg] || t("ratyrate.noRateMsg")
    space = options[:space] || false
    single = options[:single] || false
    target = options[:target] || ""
    targetText = options[:targetText] || ""
    targetType = options[:targetType] || t("ratyrate.hint")
    targetFormat = options[:targetFormat] || t("ratyrate.targetFormat")
    targetScore = options[:targetScore] || ""
    readonly = options[:readonly] || false

    disable_after_rate = options[:disable_after_rate] || true

    if disable_after_rate
      readonly = !rateable_obj.can_rate?(current_user, dimension)
    end

    content_tag :span, "", class: "star", data: {dimension: dimension,
      rating: stars, id: rateable_obj.id, classname: rateable_obj.class.name,
      disable_after_rate: disable_after_rate, readonly: readonly,
      enable_half: enable_half, half_show: half_show, star_count: star,
      star_path: star_path, star_on: star_on, star_off: star_off,
      star_half: star_half, cancel: cancel, cancel_place: cancel_place,
      cancel_hint: cancel_hint, cancel_on: cancel_on, cancel_off: cancel_off,
      no_rated_message: noRatedMsg, space: space, single: single,
      target: target, target_text: targetText, target_type: targetType,
      target_format: targetFormat, target_score: targetScore}
  end
end
