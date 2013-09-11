module Hermitage
  
  module ViewHelpers

    # Renders gallery markup.
    #
    # Arguments:
    # * +objects+   Array of objects that should be rendered.
    # * +options+   Hash of options. There is list of available options in Defaults module.
    # 
    # Examples:
    #
    #   render_gallery_for @images      # @images here is array of Image instances
    #   render_gallery_for album.photos # album.photos is array of Photo instances
    #
    # it will render the objects contained in array and will use :images (or :photos) as config name.
    # Config names are formed by the class name of the first element in array by Configurator.
    #
    def render_gallery_for(objects, options = {})
      options = Configurator.options_for(objects, options)

      # Create array of all list tags
      lists = unless options[:each_slice]
        [objects]
      else
        objects.each_slice(options[:each_slice]).to_a
      end

      # The resulting tag
      tag = ''

      # Render each list into `tag` variable
      lists.each do |list|
        # Array of items in current list
        items = list.collect do |item|
          original_path = eval("item.#{options[:original]}")
          thumbnail_path = eval("item.#{options[:thumbnail]}")
          title = options[:title] ? eval("item.#{options[:title]}") : nil
          image = image_tag(thumbnail_path, class: options[:image_class])
          link_to(image, original_path, rel: 'hermitage', class: options[:link_class], title: title)
        end
        
        # Convert these items into content tag string
        tag << content_tag(options[:list_tag], class: options[:list_class]) do
          items.collect { |item| concat(content_tag(options[:item_tag], item, class: options[:item_class])) }
        end
      end

      tag.html_safe
    end

  end
  
end