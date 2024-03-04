module TurboClone::FramesHelper
  def turbo_frame_tag(resource, &block)
    # respond_to?(:to_key) is true for ActiveRecord objects (eg. Article.first) and false for eg. strings
    id = resource.respond_to?(:to_key) ? dom_id(resource) : resource

    tag.turbo_frame(id: id, &block)
  end
end
