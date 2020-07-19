# encounter builder and inventory of a specific template so rooms can build an instance

class Template
  attr_reader :inv, :des
  
  def initialize(encounter: nil , inventory: [], description:)
    @enc = encounter || ->{ NoEnc.new } 
    @inv = inventory
    @des = description
  end
  
  # i'll return a built Encounter (like Cow or Assassin)
  def build_encounter
    @enc.call
  end

end
