require "./test_helper"

class RenderApp < Artanis::Application
  views_path "#{ __DIR__ }/views"

  get "/" do
    @message = "message: index"
    ecr "index"
  end

  get "/custom" do
    @message = "message: custom"
    ecr "index", layout: "custom"
  end

  get "/raw" do
    ecr "raw", layout: false
  end
end

class Artanis::RenderTest < Minitest::Test
  def test_render
    response = call("GET", "/")
    assert_match /INDEX/, response.body
    assert_match /LAYOUT: DEFAULT/, response.body
    assert_match /message: index/, response.body
  end

  def test_no_layout
    response = call("GET", "/raw")
    assert_match /RAW/, response.body
    refute_match /LAYOUT/, response.body
  end

  def test_specified_layout
    response = call("GET", "/custom")
    assert_match /LAYOUT: CUSTOM/, response.body
    assert_match /message: custom/, response.body
  end

  def call(request, method)
    RenderApp.call(HTTP::Request.new(request, method))
  end
end
