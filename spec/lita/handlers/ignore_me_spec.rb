require "spec_helper"

describe Lita::Handlers::IgnoreMe, lita_handler: true do
  before :example do
    @bob = Lita::User.create(123, name: "Bob")
    @room_a = Lita::Room.create_or_update("#room-a", name: "#a")
    @room_b = Lita::Room.create_or_update("#room-b", name: "#b")
  end

  context "routing" do
    it { is_expected.to route_command("ignore me").to(:ignore_me) }
    it { is_expected.to route_command("IGNORE ME").to(:ignore_me) }
    it { is_expected.to route_command("ignore me in #some-room").to(:ignore_me_in_room) }

    it { is_expected.to route_command("listen to me").to(:listen_to_me) }
    it { is_expected.to route_command("LISTEN TO ME").to(:listen_to_me) }
    it { is_expected.to route_command("listen to me in #some-room").to(:listen_to_me_in_room) }
  end

  context "when bob is not being ignored" do
    it "tells bob it will ignore him upon request" do
      send_command("ignore me", as: @bob, from: @room_a)
      expect(replies.last).to eq "Okay Bob, I will ignore you in #a unless you address me directly."
    end

    it "tells bob it will ignore him when he asks to be ignored in a different room" do
      send_command("ignore me in #b", as: @bob, from: @room_a)
      expect(replies.last).to eq "Okay Bob, I will ignore you in #b unless you address me directly."
    end

    it "tells bob it cannot find a non-existent room when he requests to be ignored" do
      send_command("ignore me in #non-room", as: @bob, from: @room_a)
      expect(replies.last).to eq "I'm sorry Bob, I'm afraid I can't do that. That room doesn't exist."
    end

    it "tells bob it is not ignoring him if he requests that the robot listen" do
      send_command("listen to me", as: @bob, from: @room_a)
      expect(replies.last).to eq "Don't worry Bob, I'm not ignoring you in #a! :heart:"
    end

    it "tells bob it cannot find a non-existent room when he requests the robot listen" do
      send_command("listen to me in #non-existent", as: @bob, from: @room_a)
      expect(replies.last).to eq "I'm sorry Bob, I'm afraid I can't do that. That room doesn't exist."
    end
  end

  context "when bob is being ignored in #a" do
    before :example do
      send_command("ignore me", as: @bob, from: @room_a)
    end

    it "tells bob he is no longer ignoring him upon request" do
      send_command("listen to me", as: @bob, from: @room_a)
      expect(replies.last).to eq "Okay Bob, I'm listening to you in #a."
    end

    it "tells bob it is already ignoring him if he requests to be ignored" do
      send_command("ignore me", as: @bob, from: @room_a)
      expect(replies.last).to eq "I'm already ignoring you in #a, Bob."
    end
  end
end
