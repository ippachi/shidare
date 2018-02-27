require_relative './support/registration'

RSpec.describe Shidare::Registration do
  describe '#signup_as' do
    let(:action) { SignupAs.new }
    let(:params) { { user: { name: 'test_name', email: 'test@example.com', password: 'password' } } }

    context 'when include' do
      context 'Model not exists' do
        subject do
          lambda {
            module AAARegistration
              include Shidare::Registration
            end
          }
        end

        it { is_expected.to raise_error(NameError) }
      end
    end

    context 'vaild' do
      it 'returns 200' do
        response = action.call(params)
        expect(response[0]).to eq 200
      end

      example 'user count should increment' do
        action.call(params)
        user_count = UserRepository.new.all.count
        expect(user_count).to eq 1
      end

      context 'mail activation' do
        let(:params) { { admin: { email: 'test@example.com', password: 'password' } } }
        let(:action) { SignupAsWithMail.new }

        it 'deliverd email' do
          action.call(params)
          mail_count = Hanami::Mailer.deliveries.count
          expect(mail_count).to eq 1
        end

        context 'model has no encrypted_password column' do
          let(:action) { InvalidModel.new }
          let(:params) { { pelple: { email: 'test@example.coi', password: 'password' } } }
          subject do
            lambda {
              action.instance_eval do
                signup_as(params)
              end
            }
          end

          it { is_expected.to raise_error(Shidare::AttributesError) }
        end
      end
    end
  end

  describe '#activate_[entity_name]' do
    let(:action) { Activation.new }
    before do
      AdminRepository.new.create(email: 'test@example.com', encrypted_password: 'password', activation_token: 'test_token')
    end

    context 'valid parameter' do
      let(:params) { { email: 'test@example.com', activation_token: 'test_token' } }
      it 'fill activated_at' do
        action.call(params)
        activated_at = AdminRepository.new.first.activated_at
        expect(activated_at).to be_truthy
      end
    end

    context 'invalid parameter' do
      let(:params) { { email: 'test@example.com', activation_token: 'invalid_token' } }
      it 'not fill activated_at' do
        action.call(params)
        activated_at = AdminRepository.new.first.activated_at
        expect(activated_at).to be_falsey
      end
    end
  end

  describe 'Hanami::Entity#acivated?' do
    let(:admin) { AdminRepository.new.first }
    subject { admin.activated? }

    context 'have activated' do
      before do
        AdminRepository.new.create(email: 'test@example.com', encrypted_password: 'password', activated_at: Time.now)
      end

      it { is_expected.to be true }
    end

    context 'have not activated' do
      before do
        AdminRepository.new.create(email: 'test@example.com', encrypted_password: 'password', activated_at: nil)
      end

      it { is_expected.to be false }
    end
  end
end
