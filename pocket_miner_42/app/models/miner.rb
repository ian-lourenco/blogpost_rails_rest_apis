class Miner < ApplicationRecord
  has_many :rare_gems, dependent: :destroy
end
