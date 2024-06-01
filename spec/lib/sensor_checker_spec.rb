require 'rails_helper'

RSpec.describe SensorChecker do
  include ActionMailer::TestHelper

  describe "running the checker" do
    let!(:checker) { SensorChecker.new }
    let!(:sensor) { create(:sensor, active: false, lower_limit: 0.0, upper_limit: 10.0, fail_count_for_value_alert: 2) }

    before do
      allow(checker).to receive(:recover_from)
      allow(checker).to receive(:send_alert)
    end

    context "when no active sensors are found" do
      it "does nothing" do
        checker.run
        expect(checker).to_not have_received(:recover_from)
        expect(checker).to_not have_received(:send_alert)
      end
    end

    context "when an active sensor is found" do
      before do
        sensor.update(active: true)
      end

      context "but the sensor has no readings" do
        it "calls send_alert with category :missing" do
          checker.run
          expect(checker).to have_received(:send_alert).with(:missing, sensor, anything)
          expect(checker).to_not have_received(:recover_from).with(:missing, sensor)
        end
      end

      context "and the sensor has at least one reading" do
        let!(:reading) { create(:reading, sensor: sensor, value: 11.0, recorded_at: 2.hours.ago - 1.minute) }

        it "calls recover_from with category :missing" do
          checker.run
          expect(checker).to_not have_received(:send_alert).with(:missing, sensor, anything)
          expect(checker).to have_received(:recover_from).with(:missing, sensor)
        end

        context "when the reading was recorded more than two hours ago" do
          it "calls send_alert with category :time" do
            checker.run
            expect(checker).to have_received(:send_alert).with(:time, sensor, reading)
            expect(checker).to_not have_received(:recover_from).with(:time, sensor)
          end
        end

        context "when the reading was recorded less than two hours ago" do
          before { reading.update(recorded_at: 2.hours.ago + 1.minute) }

          it "calls recover_from with category :time" do
            checker.run
            expect(checker).to_not have_received(:send_alert).with(:time, sensor, reading)
            expect(checker).to have_received(:recover_from).with(:time, sensor)
          end

          context "when the reading has a value outside of the limits" do
            context "when the fail_count_for_value_alert has not been reached" do
              it "does not send an alert" do
                checker.run
                expect(checker).to_not have_received(:send_alert)
                expect(checker).to_not have_received(:recover_from).with(:value, sensor)
              end
            end

            context "when the fail_count_for_value_alert has been reached" do
              before { sensor.update(fail_count_for_value_alert: 1) }

              it "calls send_alert with category :value" do
                checker.run
                expect(checker).to have_received(:send_alert).with(:value, sensor, reading)
                expect(checker).to_not have_received(:recover_from).with(:value, sensor)
              end
            end
          end

          context "when the reading has a value inside of the limits" do
            before { reading.update(value: 9.0) }

            it "calls recover_from with category :value" do
              checker.run
              expect(checker).to_not have_received(:send_alert).with(:value, sensor, reading)
              expect(checker).to have_received(:recover_from).with(:value, sensor)
            end
          end
        end
      end
    end
  end

  describe "recovering from an alert" do
    let!(:checker) { SensorChecker.new }
    let!(:sensor) { create(:sensor, active: false, lower_limit: 0.0, upper_limit: 10.0) }
    let!(:alert) { create(:alert, sensor: sensor, category: :missing, resolved_at: 10.minutes.ago) }

    context "when no current alerts exist for the given category and sensor" do
      it "does nothing" do
        expect{checker.send(:recover_from, :missing, sensor)}.to_not change(alert, :resolved_at)
      end
    end

    context "when a current alert exists for the given category and sensor" do
      before { alert.update(resolved_at: nil) }

      it "updates the resolved_at on the most recent alert" do
        expect{checker.send(:recover_from, :missing, sensor)}.to change{alert.reload.resolved_at}
        expect(alert.resolved_at).to be_within(1.second).of Time.now
      end
    end
  end

  describe "sending an alert" do
    let!(:checker) { SensorChecker.new }
    let!(:sensor) { create(:sensor, active: false, lower_limit: 0.0, upper_limit: 10.0, alert_recipients: '+61412345678,+61412345679') }
    let!(:reading) { double(:reading) }
    let!(:alert) { create(:alert, sensor: sensor, category: :missing, resolved_at: 10.minutes.ago) }
    let!(:messages_mock) { double(:messages) }
    let!(:sms_client_mock) { double(:sms_client, messages: messages_mock )}

    before do
      allow(checker).to receive(:body_for) { "some message" }
      allow(checker).to receive(:sms_client) { sms_client_mock }
      allow(messages_mock).to receive(:create)
    end

    context "when no current alerts exist for the given category and sensor" do
      context 'when there is no issue communicating with Twilio' do
        it "sends an sms to each recipient, and creates a new alert" do
          expect{checker.send(:send_alert, :missing, sensor, reading)}.to change(Alert, :count).by(1)
          expect(messages_mock).to have_received(:create).with({from: 'BBFHMonitor', to: '+61412345678', body: 'some message'})
          expect(messages_mock).to have_received(:create).with({from: 'BBFHMonitor', to: '+61412345679', body: 'some message'})
        end
      end

      context 'when there is an issue communicating with Twilio' do
        before do
          allow(messages_mock).to receive(:create).and_raise(Twilio::REST::TwilioError)
        end

        it 'sends an email instead' do
          assert_emails(1) { checker.send(:send_alert, :missing, sensor, reading) }
          last_email = ActionMailer::Base.deliveries.last
          expect(last_email.body.to_s).to match("^some message")
          expect(last_email.subject).to match(/^Alert for sensor: /)
        end
      end
    end

    context "when a current alert exists for the given category and sensor" do
      before { alert.update(resolved_at: nil) }

      context "and the alert is less than 3 hours old" do
        before { alert.update(created_at: 3.hours.ago + 1.minute) }

        it "does not send any sms or email, or create a new alert" do
          assert_emails(0) do
            expect{checker.send(:send_alert, :missing, sensor, reading)}.to_not change(Alert, :count)
            expect(checker).to_not have_received(:body_for)
            expect(messages_mock).to_not have_received(:create)
          end
        end
      end

      context "and the alert is more than three hours old" do
        before { alert.update(created_at: 3.hours.ago - 1.minute) }

        context "and the alert has not been slept" do
          context 'when there is no issue communicating with Twilio' do
            it "sends an 'ESCALATION' sms to each recipient, does not create a new alert" do
              expect{checker.send(:send_alert, :missing, sensor, reading)}.to_not change(Alert, :count)
              expect(messages_mock).to have_received(:create).with({from: 'BBFHMonitor', to: '+61412345678', body: 'ESCALATION: some message'})
              expect(messages_mock).to have_received(:create).with({from: 'BBFHMonitor', to: '+61412345679', body: 'ESCALATION: some message'})
            end

            it 'sends an email' do
              assert_emails(1) { checker.send(:send_alert, :missing, sensor, reading) }
              last_email = ActionMailer::Base.deliveries.last
              expect(last_email.body.to_s).to eq("ESCALATION: some message\n")
              expect(last_email.subject).to match(/^Alert for sensor: /)
            end
          end

          context 'when there is an issue communicating with Twilio' do
            before do
              allow(messages_mock).to receive(:create).and_raise(Twilio::REST::TwilioError)
            end

            it 'still sends an email' do
              assert_emails(1) { checker.send(:send_alert, :missing, sensor, reading) }
              last_email = ActionMailer::Base.deliveries.last
              expect(last_email.body.to_s).to match("^ESCALATION: some message")
              expect(last_email.subject).to match(/^Alert for sensor: /)
            end
          end
        end

        context "and the alert has been slept" do
          before { alert.update(sleep_until: Time.now + 1.minute) }

          context "and the sleep timer has not expired" do
            it "does not send any sms or email, or create a new alert" do
              assert_emails(0) do
                expect{checker.send(:send_alert, :missing, sensor, reading)}.to_not change(Alert, :count)
                expect(checker).to_not have_received(:body_for)
                expect(messages_mock).to_not have_received(:create)
              end
            end
          end

          context "and the sleep timer has expired" do
            before { alert.update(sleep_until: Time.now - 1.minute) }

            context 'when there is no issue communicating with Twilio' do
              it "sends an 'ESCALATION' sms to each recipient, does not create a new alert" do
                expect{checker.send(:send_alert, :missing, sensor, reading)}.to_not change(Alert, :count)
                expect(messages_mock).to have_received(:create).with({from: 'BBFHMonitor', to: '+61412345678', body: 'ESCALATION: some message'})
                expect(messages_mock).to have_received(:create).with({from: 'BBFHMonitor', to: '+61412345679', body: 'ESCALATION: some message'})
              end

              it 'sends an email' do
                assert_emails(1) { checker.send(:send_alert, :missing, sensor, reading) }
                last_email = ActionMailer::Base.deliveries.last
                expect(last_email.body.to_s).to eq("ESCALATION: some message\n")
                expect(last_email.subject).to match(/^Alert for sensor: /)
              end
            end

            context 'when there is an issue communicating with Twilio' do
              before do
                allow(messages_mock).to receive(:create).and_raise(Twilio::REST::TwilioError)
              end

              it 'still sends an email' do
                assert_emails(1) { checker.send(:send_alert, :missing, sensor, reading) }
                last_email = ActionMailer::Base.deliveries.last
                expect(last_email.body.to_s).to match("^ESCALATION: some message")
                expect(last_email.subject).to match(/^Alert for sensor: /)
              end
            end
          end
        end
      end
    end
  end

  describe "contructing a message body" do
    let!(:checker) { SensorChecker.new }
    let!(:sensor) { create(:sensor, active: false, lower_limit: 0.0, upper_limit: 10.0) }
    let!(:reading1) { create(:reading, sensor: sensor, value: 11.0, recorded_at: 30.minutes.ago) }
    let!(:reading2) { create(:reading, sensor: sensor, value: 12.0, recorded_at: 90.minutes.ago) }
    let!(:reading3) { create(:reading, sensor: sensor, value: 13.0, recorded_at: 150.minutes.ago) }

    context "when fail_count_for_value_alert is 1" do
      before do
        sensor.update(fail_count_for_value_alert: 1)
      end

      it "reports the most recent reading value in the message body" do
        body = checker.send(:body_for, :value, sensor, reading1)
        expect(body).to include "(11.0)"
      end
    end

    context "when fail_count_for_value_alert is greater than 1" do
      before do
        sensor.update(fail_count_for_value_alert: 3)
      end

      it "reports n values in the message body, where n = fail_count_for_value_alert" do
        body = checker.send(:body_for, :value, sensor, reading1)
        expect(body).to include "(11.0, 12.0, 13.0)"
      end
    end
  end
end
