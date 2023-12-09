# == Schema Information
#
# Table name: equipment
#
#  id         :integer          not null, primary key
#  limits     :integer
#  slot       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  model_id   :integer          not null
#  weapon_id  :integer          not null
#
# Indexes
#
#  index_equipment_on_model_id   (model_id)
#  index_equipment_on_weapon_id  (weapon_id)
#
class Equipment < ApplicationRecord
  belongs_to :model
  belongs_to :weapon

  # has_many :weapon, class_name: "Weapon", foreign_key: "weapon_id"
  
  # has_many :melee_weapon, -> {weapon.select(range: 0)}
  #scope :melee, -> { where range: 0 }
end
