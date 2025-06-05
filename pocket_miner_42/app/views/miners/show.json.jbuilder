json.miner do
  json.name @miner.name
  json.level @miner.level
  json.rare_gems @miner.rare_gems do |rare_gem|
    json.name rare_gem.name
    json.color rare_gem.color
  end
  json.created_at @miner.created_at.iso8601
  json.updated_at @miner.updated_at.iso8601
end
