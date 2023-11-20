
namespace :slurp do
  desc "tyranid name/stats"
  task tyranid_weapons: :environment do
    require "csv"
    csv_text = File.read(Rails.root.join("lib", "sample_data", "tyranids_weapons.csv"))
    csv = CSV.parse(csv_text, :headers => true, :encoding => "ISO-8859-1")
    csv.each do |row|
      name = row["Name"]
      unit = Unit.where(name: name).first
      weapon_name = row["Weapon_Name"]
      if Weapon.where(name: weapon_name).last
        if row["Profile"]
          puts weapon_name + " - " + row["Profile"]
          
        else
          puts weapon_name
        end
      else
        if row["Profile"]
          puts weapon_name + " - " + row["Profile"]
          
        else
          w = Weapon.new
          p = Profile.new
          w.name = weapon_name
          end
      end
    end
  end
  desc "tyranid name/stats"
  task tyranid_stats: :environment do
    require "csv"
    csv_text = File.read(Rails.root.join("lib", "sample_data", "tyranids_stats.csv"))
    csv = CSV.parse(csv_text, :headers => true, :encoding => "ISO-8859-1")
    f = Faction.new
    f.name = "Tyranids2"
    f.save
    csv.each do |row|
      #Adding unit
      u = Unit.new
      u.name = row["Unit_Name"]
      u.faction_id = f.id
      u.base_size = row["Base_Size"]
      u.save
      #Adding Models
      m = Model.new
      m.name = row["Model_Name"]
      m.invulnerable_save = row["Invurebale_Save"]
      m.leadership = row["Ld"]
      m.movement = ["M"]
      m.objective_control = ["OC"]
      m.save_value = row["Sv"]
      m.toughness = row["T"]
      m.wounds = row["W"]
      m.unit_id = Unit.where(name: u.name).first.id
      m.save
    end
  end
  
  desc "tyranid abilities"
  task tyranid_abilities: :environment do
    require "csv"
    require "json"
    csv_text = File.read(Rails.root.join("lib", "sample_data", "tyranids_abilities.csv"))
    csv = CSV.parse(csv_text, :headers => true, :encoding => "ISO-8859-1")
    csv.each do |row|
      #Core Abilities
      name = row["Unit_Name"]
      unit = Unit.where(name: name).first
      core = JSON.parse(row["Core"])
      core.each do |ability|
        if ability === "CORE"
        else
          if Ability.where(name: ability).last
            a = Ability.where(name: ability).last
            u = UnitAbility.new
            u.ability_id = a.id
            u.unit_id = unit.id
            u.save
            #puts unit.name
            #puts u.valid?
            #puts u.errors.full_messages
          else
            u = UnitAbility.new
            a = Ability.new
            a.name = ability
            a.classification = core
            a.save
            new_ability = Ability.where("created_at").last
            u.save
            u.unit_id = unit.id
            u.ability_id = Ability.where(name: ability).last.id
          end
        end
      end
      #next Faction
      faction = JSON.parse(row["Faction"])
      faction.each do |ability|
        if ability === "FACTION"
        else
          if Ability.where(name: ability).last
            a = Ability.where(name: ability).last
            u = UnitAbility.new
            u.ability_id = a.id
            u.unit_id = unit.id
            u.save
          else
            u = UnitAbility.new
            a = Ability.new
            a.name = ability
            a.classification = "faction"
            a.save
            new_ability = Ability.where("created_at").last
            u.save
            u.unit_id = unit.id
            u.ability_id = Ability.where(name: ability).last.id
          end
        end
      end
      #standard abilities
      standard = JSON.parse(row["Standard"])
      standard.each do |ability|
        if Ability.where(name:  ability[0]).last
          a = Ability.where(name: ability).last
          u = UnitAbility.new
          u.ability_id = a.id
          u.unit_id = unit.id
          u.save
        else
          u = UnitAbility.new
          a = Ability.new
          a.name = ability[0]
          a.description = ability[1]
          a.classification = "standard"
          a.save
          new_ability = Ability.where("created_at").last
          u.save
          u.unit_id = unit.id
          u.ability_id = Ability.where(name: ability).last.id
        end
      end
      cost = JSON.parse(row["Cost"])
      unit.models_per_unit = cost[0][0]
      unit.max_size = cost.length()
      unit.cost = cost[0][1]
      unit.save
      #Wargear, needs to be changed for other factions
      if row["Wargear"]
        wargear = JSON.parse(row["Wargear"])
        if Ability.where(name:  wargear[0]).last
          a = Ability.where(name: wargear[0]).last
          u = UnitAbility.new
          u.ability_id = a.id
          u.unit_id = unit.id
          u.save
        else
          u = UnitAbility.new
          a = Ability.new
          a.name = wargear[0]
          a.description = wargear[1]
          a.classification = "wargear"
          a.save
          new_ability = Ability.where("created_at").last
          u.save
          u.unit_id = unit.id
          u.ability_id = Ability.where(name: wargear[0]).last.id
        end
      end
    end
  end

end
