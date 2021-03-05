Dir["./interface/game/encounters/*.rb"].each do |file_name|
  require file_name
end

RSpec.describe "NoEnc" do
  context "when a default NoEnc is created" do
    subject { NoEnc.new }
    
    it "returns false for blocking" do
      expect(subject.blocking).to eq(false)
    end
    
    it "returns false for handle command" do
      expect(subject.handle_command("cmdstr", "avatar")).to eq(false)
    end
    
    it "returns the right string for hint" do
      expect(subject.hint).to be_a(String)
      expect(subject.hint).to eq("No seriously. There's no encounter here.")
    end
    
    it "returns the right string for state" do
      expect(subject.state).to be_a(String)
      expect(subject.state).to eq("")
    end
  end
end

RSpec.describe "Avalanche" do
  context " when an Avalanche is created" do
    subject { Avalanche.new }
    
    context "the default init" do
      it "returns false for blocking" do
        expect(subject.blocking).to eq(false)
      end
      
      it "returns false for unsupported command" do
        expect(subject.handle_command("cmdstr", "avatar")).to eq(false)
      end
      
      it "returns the right string for unblocked state" do
        no_block_string = "There's a huge pile of rocks. It kind of reminds you of the Alpine Mountains."
        
        expect(subject.state).to eq(no_block_string)
      end
      
      it "returns the right string for hint" do
        expect(subject.hint).to be_a(String)
        expect(subject.hint).to eq("If you're daring, a yodel might do something.")
      end
    end
    
    context "after the correct command is used" do
      it "returns correct string & blocks for supported command" do
        string = "Rocks fall; You almost die. That was too daring."
        expect(subject.handle_command("yodel", "avatar")).to eq(string)
        expect(subject.blocking).to eq(true)
      end
      
      it "returns the right string for blocked state" do
        block_string = "The rocks have fallen and there is no path here."
        
        subject.handle_command("yodel", "avatar")
        expect(subject.state).to eq(block_string)
      end
    end
  end
end

RSpec.describe "Cow" do
  context "when a cow is created" do
    subject { Cow.new }
    
    context "the default init" do
      it "returns false for blocking" do
        expect(subject.blocking).to eq(false)
      end
      
      it "returns false for unsupported command" do
        expect(subject.handle_command("cmdstr", "avatar")).to eq(false)
      end
      
      it "returns the right string for hint" do
        expect(subject.hint).to be_a(String)
        expect(subject.hint).to eq("Cows produce a LOT of milk each day.")
      end
      
      it "state returns the right string for unmilked" do
        unmilked_string = "There is a cow looking at you. She looks really uncomfortable."
        
        expect(subject.state).to eq(unmilked_string)
      end
    end
    
    context "when a player tries to milk the cow" do
      let(:avatar) { double("avatar", :inventory => double("inventory", :add_new_item => "added")) }
      
      it "returns correctly for first milk command" do
        string = "You get some milk."
        expect(avatar.inventory).to receive(:add_new_item).with(name: "milk")
        expect(subject.handle_command("milk cow", avatar)).to eq(string)
        expect(subject.blocking).to eq(false)
      end
      
      it "returns correctly for second milk command" do
        string = "You get the rest of the milk."
        expect(avatar.inventory).to receive(:add_new_item).with(name: "milk").twice
        subject.handle_command("milk cow", avatar)
        
        expect(subject.handle_command("milk cow", avatar)).to eq(string)
        expect(subject.blocking).to eq(false)
      end
      
      context "with a twice-milked cow" do
        before do
          subject.handle_command("milk cow", avatar)
          subject.handle_command("milk cow", avatar)
        end
        it "returns correctly for third milk command" do
          string = "Bessy is not going to let you near her again today."
          expect(avatar.inventory).not_to receive(:add_new_item).with(name: "milk")
          expect(subject.handle_command("milk cow", avatar)).to eq(string)
          expect(subject.blocking).to eq(false)
        end
      end
    end
    
    context "when a player tries to kill the cow" do
      let(:avatar) { double( "avatar",{
        :has_item? => weapon,
        :inventory => double("inventory", :remove_item => "removed"),
        :leave => "called leave",
          }
        )
      }
  
      context "and you don't have a knife" do
        let(:weapon) { false }

        it "returns correctly for kill command" do
          string = "Whoops! No knife in inventory. "
          expect(subject.handle_command("kill cow", avatar)).to eq(string)
        end
      end
  
      context "and you do have a knife" do
        let(:weapon) { true }

        it "returns correctly for kill command" do
          string = "She sees you comming and kicks you into next week. You die bleeding out on the rug. Game Over!"

          expect(avatar).to receive(:leave).with(string)
          subject.handle_command("kill cow", avatar)
        end
      end
    end

    context "after being milked twice" do
    let(:avatar) { double("avatar", :inventory => double("inventory", :add_new_item => "added"))  }
  
      it "state returns the right string for milked-out" do
        milkedout_string = "The cow is happy."
    
        subject.handle_command("milk", avatar)
        subject.handle_command("milk", avatar)
        expect(subject.state).to eq(milkedout_string)
      end
    end
  end
end

RSpec.describe "Fire" do
  context "when a fire is created" do
    subject { Fire.new }

    context "the default init" do
      it "returns true for blocking" do
        expect(subject.blocking).to eq(true)
      end
      
      it "returns false for unsupported command" do
        expect(subject.handle_command("cmdstr", "avatar")).to eq(false)
      end
      
      it "returns the right string for hint" do
        hint_string = "Liquids are often used to put out fires."
        expect(subject.hint).to be_a(String)
        expect(subject.hint).to eq(hint_string)
      end
      
      it "state returns the right string for blocking" do
        blocking_string = "OMG the table's on fire!"
        
        expect(subject.state).to eq(blocking_string)
      end
    end
    
    context "after the correct command is given" do
      context "and the user does not have milk" do
        let(:avatar) { double("avatar", :has_item? => false) }
        
        it "returns the right strings for no milk" do
          missing_string = "Whoops! No milk in inventory. "
          state_string = "OMG the table's on fire!"
          
          expect(subject.handle_command("use milk", avatar)).to eq(missing_string)
          expect(subject.state).to eq(state_string)
        end
      end
      
      context "and the user does have milk" do
        let(:avatar) { double("avatar", :has_item? => true, :inventory => double("inventory", :remove_item => true)) }
        
        it "returns the right strings for unblocked state" do
          completed_string = "The fire dies down."
          state_string = "The table is singed where it used to be on fire."
          
          expect(subject.handle_command("use milk", avatar)).to eq(completed_string)
          expect(subject.state).to eq(state_string)
        end
      end
    end
  end
end

RSpec.describe "Ice" do
  context "when a ice is created" do
    subject { Ice.new }
    
    context "the default init" do
      it "returns false for blocking" do
        expect(subject.blocking).to eq(false)
      end
      
      it "returns false for unsupported command" do
        expect(subject.handle_command("cmdstr", "avatar")).to eq(false)
      end
      
      it "returns the right string for hint" do
        hint_string = "If you try to hurry, you might slip on ice."
        
        expect(subject.hint).to be_a(String)
        expect(subject.hint).to eq(hint_string)
      end
      
      it "state returns the right string" do
        state_string = "The floor is super slippery in here."
        
        expect(subject.state).to eq(state_string)
      end
    end
    
    context "after a valid command is given" do
      let(:avatar) { double("avatar",{ :leave => "called leave" }) }
      
      it "returns correctly for hurry command" do
        dead_string = "You slip and fall cracking your head open. I told you it was slippery. Game over!"
        expect(avatar).to receive(:leave).with(dead_string)
        subject.handle_command("hurry", avatar)
      end
    end
  end
end

RSpec.describe "Jester" do
  context "when a jester is created" do
    subject { Jester.new }
    
    context "the default init" do
      it "returns true for blocking" do
        expect(subject.blocking).to eq(true)
      end
      
      it "returns false for unsupported command" do
        expect(subject.handle_command("cmdstr", "avatar")).to eq(false)
      end
      
      it "returns the right string for hint" do
        hint_string = "Just give him what he wants."
        
        expect(subject.hint).to be_a(String)
        expect(subject.hint).to eq(hint_string)
      end
      
      it "state returns the right string for blocking" do
        state_string = "The jester peeks around the throne asking you to tell a joke."
        
        expect(subject.state).to eq(state_string)
      end
    end
    
    context "after a valid command is given" do
      let(:inventory) { double("inventory", :add_new_item => true) }
      let(:avatar) { double("avatar", :leave => "called leave", 
                                      :inventory => inventory, 
                            ) 
                    }
      let(:tell_joke) { subject.handle_command("tell joke", avatar) }

      it "returns correctly for tell joke command" do
        return_string = "Pleased with your wit, the jester sits to whittle a flute."
        
        expect(inventory).to receive(:add_new_item).with(name: "laughter", type: "mood")
        expect(tell_joke).to eq(return_string)
        expect(subject.blocking).to eq(false)
      end

      it "state returns the right string for unblocked" do
        state_string = ""
      
        tell_joke
        expect(subject.state).to eq(state_string)
      end
    end
  end
end

RSpec.describe "Killer" do
  context "when a killer is created" do
    subject { Killer.new }
    missing_item_string = "Whoops! You don't seem to have the item to do that in your inventory. "

    context "the default init" do
      it "returns true for blocking" do
        expect(subject.blocking).to eq(true)
      end
      
      it "returns false for unsupported command" do
        expect(subject.handle_command("cmdstr", "avatar")).to eq(false)
      end
      
      it "returns the right string for hint" do
        hint_string = "Friend or foe? That's up to you."
        
        expect(subject.hint).to be_a(String)
        expect(subject.hint).to eq(hint_string)
      end
      
      it "state returns the right string for blocking" do
        state_string = "In the room you see a man in leather armour. His sword is at his side. This guy \ndoesn't look like the type who laughs easily. He looks at you and asks if you \nhave something for him.\n"
        
        expect(subject.state).to eq(state_string)
      end
    end

    context "when entering the command"
    # Every "give snark" is not implemented yet  

      # this is all wrong. I need a semi fake avatar so I can call 
      # the usual stuff on it and just swap values in first

      # context "kill man" do
      #   context "without a knife" do
      #     user = { :has_weapon => false }

      #     it "provides the missing item hint" do
      #       expect(subject.handle_command("kill man", user)).to do
      #         a bunch of stuff
      #       end
      #     end
      #   end
      #
      #   context "with a knife" do
      #     user = { :has_weapon => "knife" }

      #     it "works" do
      #       expect(subject.handle_command("kill man", user)).to do
      #         a bunch of other stuff
      #       end
      #     end
      #   end

      #   context "but the killer was already dead" do
      #     it "gives snark" do
      #       expect(true).to eq(false)
      #     end
      #   end
      # end

      context "the player offers a penny" do
        context "without the right item" do
          it "fails" do
            expect(true).to eq(false)
          end
        end
        context "with the right item" do
          it "works" do
            expect(true).to eq(false)
          end
        end
        # context "but the killer was already dead" do
        #   it "gives snark" do
        #     expect(true).to eq(false)
        #   end
        end
      end

      context "the player offers a gem" do
        context "without the right item" do
          it "fails" do
            expect(true).to eq(false)
          end
        end
        context "with the right item" do
          it "works" do
            expect(true).to eq(false)
          end
        end
        # context "but the killer was already dead" do
        #   it "gives snark" do
        #     expect(true).to eq(false)
        #   end
        end
      end

      context "the player offers gold" do
        context "without the right item" do
          it "fails" do
            expect(true).to eq(false)
          end
        end
        context "with the right item" do
          it "works" do
            expect(true).to eq(false)
          end
        end
        # context "but the killer was already dead" do
        #   it "gives snark" do
        #     expect(true).to eq(false)
        #   end
        end
      end

      context "the player offers milk" do
        context "without the right item" do
          it "fails" do
            expect(true).to eq(false)
          end
        end
        context "with the right item" do
          it "works" do
            expect(true).to eq(false)
          end
        end
        # context "but the killer was already dead" do
        #   it "gives snark" do
        #     expect(true).to eq(false)
        #   end
        end
      end

      context "the player offers a hug" do
        it "works" do
          expect(true).to eq(false)
        end
        
        # context "but the killer was already dead" do
        #   it "gives snark" do
        #     expect(true).to eq(false)
        #   end
        end
      end

      context "the player tells a joke" do
        it "works" do
          expect(true).to eq(false)
        end

        # context "but the killer was already dead" do
        #   it "gives snark" do
        #     expect(true).to eq(false)
        #   end
        end
      end
  end
end

end
