require "spec_helper"

describe Echo, lita_handler: true, additional_lita_handlers: Lita::Handlers::IgnoreMe do
  before :context do
    @message = "echo Goodbye, moon!"
    @echo_response = "Goodbye, moon!"
  end

  before :example do
    registry.register_hook(:validate_route, Lita::Extensions::IgnoreMe)
    @bob = Lita::User.create(123, name: "Bob")
    @room_a = Lita::Room.create_or_update("#room-a", name: "#a")
    @room_b = Lita::Room.create_or_update("#room-b", name: "#b")
  end

  it "echoes a message from bob" do
    send_message(@message, as: @bob, from: @room_a)
    expect(replies.first).to eq @echo_response
  end

  context "bob is ignored in #a" do
    before do
      send_command("ignore me", as: @bob, from: @room_a)
    end

    it "ignores bob's message in #a" do
      send_message(@message, as: @bob, from: @room_a)
      expect(replies.last).not_to eq @echo_message
    end

    it "does not ignore alice's message in #a" do
      send_message(@message, as: Lita::User.create(456, name: "alice"), from: @room_a)
      expect(replies.last).to eq @echo_response
    end

    it "does not ignore bob's message in #b" do
      send_message(@message, as: @bob, from: @room_b)
      expect(replies.last).to eq @echo_response
    end

    it "does not ignore bob's command in #a" do
      send_command(@message, as: @bob, from: @room_a)
      expect(replies.last).to eq @echo_response
    end

    context "bob turns off ignore in #a" do
      before do
        send_command("listen to me", as: @bob, from: @room_a)
      end

      it "does not ignore bob's message in #a" do
        send_message(@message, as: @bob, from: @room_a)
        expect(replies.last).to eq @echo_response
      end
    end

  end

  context "bob requests to be ignored in #b from #a" do

    before :example do
      send_command("ignore me in #b", as: @bob, from: @room_a)
    end

    it "does not ignore bob in #a" do
      send_message(@message, as: @bob, from: @room_a)
      expect(replies.last).to eq @echo_response
    end

    it "ignores bob in #b" do
      send_message(@message, as: @bob, from: @room_b)
      expect(replies.last).not_to eq @echo_response
    end

  end

  context "bob requests to be listened to in #b from #a" do

    before :example do
      send_command("ignore me", as: @bob, from: @room_a)
      send_command("ignore me", as: @bob, from: @room_b)

      send_command("listen to me in #b", as: @bob, from: @room_a)
    end

    it "continues to ignore bob in #a" do
      send_message(@message, as: @bob, from: @room_a)
      expect(replies.last).not_to eq @echo_response
    end

    it "listens to bob in #b" do
      send_message(@message, as: @bob, from: @room_b)
      expect(replies.last).to eq @echo_response
    end

  end

end
