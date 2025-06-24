json.miner do
  json.partial! 'miners/miner', miner: @miner

  json.created_at @miner.created_at.to_fs(:iso8601)
  json.updated_at @miner.updated_at.to_fs(:iso8601)

  json.rare_gems @miner.rare_gems do |gem|
    json.partial! 'gems/gem', gem: gem
  end
end
