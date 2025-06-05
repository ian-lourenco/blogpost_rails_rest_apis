json.miners @miners do |miner|
  json.name miner.name
  json.level miner.level
  json.rare_gems miner.rare_gems do |rare_gem|
    json.name rare_gem.name
    json.color rare_gem.color
  end
end
