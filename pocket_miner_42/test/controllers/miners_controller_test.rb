require "test_helper"

class MinersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @miner = miners(:one)
  end

  test "should get index" do
    get miners_url, as: :json
    assert_response :success
  end

  test "should create miner" do
    assert_difference("Miner.count") do
      post miners_url, params: { miner: { level: @miner.level, name: @miner.name } }, as: :json
    end

    assert_response :created
  end

  test "should show miner" do
    get miner_url(@miner), as: :json
    assert_response :success
  end

  test "should update miner" do
    patch miner_url(@miner), params: { miner: { level: @miner.level, name: @miner.name } }, as: :json
    assert_response :success
  end

  test "should destroy miner" do
    assert_difference("Miner.count", -1) do
      delete miner_url(@miner), as: :json
    end

    assert_response :no_content
  end
end
