Dir["./interface/game/encounters/*.rb"].each do |file_name|
  require file_name
end

RSpec.describe "Encounter" do

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

  context " when an Avalanche is created" do
    subject { Avalanche.new }

    it "returns false for blocking" do
      expect(subject.blocking).to eq(false)
    end

    it "returns false for unsupported command" do
      expect(subject.handle_command("cmdstr", "avatar")).to eq(false)
    end

    it "returns correct string & blocks for supported command" do
      string = "Rocks fall; You almost die. That was too daring."
      expect(subject.handle_command("yodel", "avatar")).to eq(string)
      expect(subject.blocking).to eq(true)
    end

    it "returns the right string for hint" do
      expect(subject.hint).to be_a(String)
      expect(subject.hint).to eq("If you're daring, a yodel might do something.")
    end
  
    it "returns the right string for unblocked state" do
      no_block_string = "There's a huge pile of rocks. It kind of reminds you of the Alpine Mountains."
  
      expect(subject.state).to eq(no_block_string)
    end

    it "returns the right string for blocked state" do
      block_string = "The rocks have fallen and there is no path here."
  
      subject.handle_command("yodel", "avatar")
      expect(subject.state).to eq(block_string)
    end
  end

  context "when a cow is created" do
    subject { Cow.new }

    it "returns false for blocking" do
      expect(subject.blocking).to eq(false)
    end

    it "returns false for unsupported command" do
      expect(subject.handle_command("cmdstr", "avatar")).to eq(false)
    end



    context "and a player tries to milk the cow" do
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


    context "and a player tries to kill the cow" do
      let(:avatar) { double( "avatar",{
                                        :has_item? => weapon,
                                        :inventory => double("inventory", :remove_item => "removed"),
                                        :leave => "called leave",
                                      }
                            )
                    }

      context "when you don't have a knife" do
        let(:weapon) { false }
        it "returns correctly for kill command" do
          string = "Whoops! No knife in inventory. "
          expect(subject.handle_command("kill cow", avatar)).to eq(string)
        end
      end

      context "when you do have a knife" do
        let(:weapon) { true }
        it "returns correctly for kill command" do
          string = "She sees you comming and kicks you into next week. You die bleeding out on the rug. Game Over!"
          expect(avatar).to receive(:leave).with(string)
          subject.handle_command("kill cow", avatar)
        end
      end
    end

    it "returns the right string for hint" do
      expect(subject.hint).to be_a(String)
      expect(subject.hint).to eq("Cows produce a LOT of milk each day.")
    end
  
    it "returns the right string for unmilked state" do
      unmilked_string = "There is a cow looking at you. She looks really uncomfortable."
  
      expect(subject.state).to eq(unmilked_string)
    end

    context "after being milked" do
      let(:avatar) { double("avatar", :inventory => double("inventory", :add_new_item => "added")) }
      
      it "returns the right string for milked-out state" do
        milkedout_string = "The cow is happy."
  
        subject.handle_command("milk", avatar)
        subject.handle_command("milk", avatar)
        expect(subject.state).to eq(milkedout_string)
      end
    end




  end


end