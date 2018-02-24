require_relative './support/user/user_registration'

RSpec.describe Shidare::Registration do
  describe '#signup_as' do
    let(:action) { SignupAs.new }
    let(:params) { { user: { name: 'test_name', email: 'test@example.com', password: 'password' } } }
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
    end

    context 'Model not exists' do
      subject do
        lambda {
          module AAARegistration
            include Shidare::Registration
          end
        }
      end

      it { is_expected.to raise_error(Shidare::ModelNotGenerated) }
    end

    context 'Model has no encrypted_password column' do
      subject do
        lambda {
          module PeopleRegistration
            include Shidare::Registration
          end
        }
      end

      it { is_expected.to raise_error(Shidare::AttributesError) }
    end
  end
end
