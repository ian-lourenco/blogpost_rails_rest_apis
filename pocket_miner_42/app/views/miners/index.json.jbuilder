json.miners @miners do |miner|
  json.partial! 'miners/miner', miner: miner
  json.rare_gems miner.rare_gems do |gem|
    json.partial! 'gems/gem', gem: gem
  end
end
