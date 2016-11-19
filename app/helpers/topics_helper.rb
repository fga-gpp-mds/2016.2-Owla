module TopicsHelper
  def get_image_dimensions image
    dimensions = Paperclip::Geometry.from_file(image.path)
    return {
      width:  dimensions.width.to_i,
      height: dimensions.height.to_i
    }
  end

  def split_slide topic
    if topic.slide.present?
      begin
        pdf = Magick::ImageList.new(topic.slide.path)
        pdf.write(slide_dir(topic) + "/slide.jpg")
      rescue => e
        flash[:alert] = "Sorry, the PDF file is corrupted."
        raise e #TODO catch this exception
      end
    end
  end

  def generate_slide_list topic
    if !dir_exists topic or !slide_splited? topic
      create_dir topic
      split_slide topic
    end

    pages = get_image_files topic
    full_uri_pages = pages.map { |page_name| "/slides/#{topic.id}/#{page_name}" }
    full_uri_pages.sort_by { |h| h.scan(/.-(\d+)\.jpg/).flatten[0].to_i }
  end

  def get_image_files topic
    list_of_files = Dir.entries(slide_dir(topic))
    list_of_files.select { |f| /.-\d+\.jpg/.match(f) }
  end

  def slide_splited? topic
    number_of_files = get_image_files(topic).count
    return number_of_files > 1
  end

  def slide_dir topic
    return "#{Rails.public_path}/slides/#{topic.id}"
  end

  def create_dir topic
    Dir.mkdir(slide_dir(topic)) unless dir_exists(topic)
  end

  def dir_exists topic
    File.exists?(slide_dir(topic))
  end

  def send_slide topic_id, slide_id, action
    ActionCable.server.broadcast 'questions',
      action: action,
      topic_id: topic_id,
      slide_id: slide_id
    head :ok
  end
end
