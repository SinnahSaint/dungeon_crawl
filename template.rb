class Template
  attr_reader :inventory, :description
  
  def initialize(encounter: nil , inventory: [], description:)
    @enc = encounter || ->{ NoEnc.new } 
    @inventory = inventory
    @description = description
  end

  def build_encounter
    @enc.call
  end

end
