require "spec_helper"

describe Lita::Handlers::IgnoreMe, lita_handler: true do
  before :example do
    @bob = Lita::User.create(123, name: "Bob")
  end

  context "routing" do
    it { is_expected.to route_command("ignore me").to(:ignore_me) }
    it { is_expected.to route_command("IGNORE ME").to(:ignore_me) }

    it { is_expected.to route_command("listen to me").to(:listen_to_me) }
    it { is_expected.to route_command("LISTEN TO ME").to(:listen_to_me) }
  end

  context "when bob is not being ignored" do
    it "tells bob it will ignore him upon request" do
      send_command("ignore me", as: @bob, from: "#a")
      expect(replies.last).to eq "Okay Bob, I will ignore you in #a unless you address me directly."
    end

    it "tells bob it is not ignoring him if he requests that the robot listen" do
      send_command("listen to me", as: @bob, from: "#a")
      expect(replies.last).to eq "Don't worry Bob, I'm not ignoring you! :heart:"
    end
  end

  context "when bob is being ignored in #a" do
    before :example do
      send_command("ignore me", as: @bob, from: "#a")
    end

    it "tells bob he is no longer ignoring him upon request" do
      send_command("listen to me", as: @bob, from: "#a")
      expect(replies.last).to eq "Okay Bob, I'm listening."
    end

    it "tells bob it is already ignoring him if he requests to be ignored" do
      send_command("ignore me", as: @bob, from: "#a")
      expect(replies.last).to eq "I'm already ignoring you in #a, Bob."
    end
  end
end
