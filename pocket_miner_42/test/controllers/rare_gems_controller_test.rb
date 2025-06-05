require "test_helper"

class RareGemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @rare_gem = rare_gems(:one)
  end

  test "should get index" do
    get rare_gems_url, as: :json
    assert_response :success
  end

  test "should create rare_gem" do
    assert_difference("RareGem.count") do
      post rare_gems_url, params: { rare_gem: { miner_id: @rare_gem.miner_id, name: @rare_gem.name } }, as: :json
    end

    assert_response :created
  end

  test "should show rare_gem" do
    get rare_gem_url(@rare_gem), as: :json
    assert_response :success
  end

  test "should update rare_gem" do
    patch rare_gem_url(@rare_gem), params: { rare_gem: { miner_id: @rare_gem.miner_id, name: @rare_gem.name } }, as: :json
    assert_response :success
  end

  test "should destroy rare_gem" do
    assert_difference("RareGem.count", -1) do
      delete rare_gem_url(@rare_gem), as: :json
    end

    assert_response :no_content
  end
end
