require 'rails_helper'

describe ApplicationHelper do
  describe '#flash_class_name' do
    context 'notice' do
      it 'returns success' do
        expect(helper.flash_class_name('notice')). to eql 'success'
      end
    end

    context 'alert' do
      it 'returns danger' do
        expect(helper.flash_class_name('alert')). to eql 'danger'
      end
    end

    context 'unrecognized' do
      it 'returns empty string' do
        expect(helper.flash_class_name('not_a_color')). to eql ''
      end
    end
  end
end
