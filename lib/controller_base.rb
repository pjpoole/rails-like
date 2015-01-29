require_relative './params'
require_relative './session'
require 'active_support/core_ext'
require 'erb'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res, route_params = {})
    @req, @res = req, res
    @already_built_response = false
    @params = Params.new(req, route_params)
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    raise if already_built_response?
    @already_built_response = true
    @res.status = 302
    @res['Location'] = url
    session.store_session(@res)
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    filename = "views/#{self.class.name.underscore}/#{template_name}.html.erb"
    file = File.read(filename)
    erb = ERB.new(file)
    content = erb.result(binding)
    render_content(content, 'text/html')
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, type)
    raise if already_built_response?
    @already_built_response = true
    @res.content_type = type
    @res.body = content
    session.store_session(@res)
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
    self.send(name)

    render(name) unless already_built_response?
  end
end
