require 'rails_helper'
# require 'spec_helper'
# require 'app/datatables/dance_datatable.rb'

describe DanceDatatable do
  describe '.filter_dances' do
    let (:dances) { [:dance, :box_the_gnat_contra, :call_me].map {|name| FactoryGirl.create(name)} }

    it 'figure' do
      filtered = DanceDatatable.send(:filter_dances, dances, ['figure', 'hey'])
      expect(filtered.map(&:title)).to eq(['Call Me'])
    end

    describe 'and' do
      it 'works' do
        filtered = DanceDatatable.send(:filter_dances, dances, ['and', ['figure', 'circle'], ['figure', 'right left through']])
        expect(filtered.map(&:title)).to eq(['Call Me'])
      end

      it 'works with none' do
        filtered = DanceDatatable.send(:filter_dances, dances, ['and', ['none', ['figure', 'chain']], ['figure', 'star']])
        expect(filtered).to eq([])        
      end
    end

    it 'or' do
      filtered = DanceDatatable.send(:filter_dances, dances, ['or', ['figure', 'circle'], ['figure', 'right left through']])
      expect(filtered.map(&:title)).to eq(dances.map(&:title))
    end

    it 'none' do
      filtered = DanceDatatable.send(:filter_dances, dances, ['none', ['figure', 'hey']])
      expect(filtered.map(&:title)).to eq(['The Rendevouz', 'Box the Gnat Contra'])
    end

    it 'all' do
      dances2 = [FactoryGirl.create(:dance_with_a_swing)] + dances
      filtered = DanceDatatable.send(:filter_dances, dances2, ['all', ['figure', 'swing']])
      expect(filtered.map(&:title)).to eq(['Monofigure'])
    end

    it 'not' do
      dances2 = [FactoryGirl.create(:dance_with_a_swing)] + dances
      filtered = DanceDatatable.send(:filter_dances, dances2, ['not', ['figure', 'swing']])
      expect(filtered.map(&:title)).to eq(['The Rendevouz', 'Box the Gnat Contra', 'Call Me'])
    end

    describe 'follows' do
      it 'basically works' do
        filtered = DanceDatatable.send(:filter_dances, dances, ['follows', ['figure', 'swing'], ['figure', 'circle']])
        expect(filtered.map(&:title)).to eq(['The Rendevouz', 'Call Me'])
      end
    end
  end

  describe '.shift_figure_indicies' do
    it 'basically works' do
      expect(DanceDatatable.shift_figure_indicies([1,3,5], 7)).to eq([2,4,6])
    end

    it 'wraps' do
      expect(DanceDatatable.shift_figure_indicies([5], 6)).to eq([0])
    end
  end

  describe '.matching_figures_for_follows' do
    it 'basically works' do
      dance = FactoryGirl.create(:box_the_gnat_contra)
      figure_indicies = DanceDatatable.matching_figures(['follows', ['figure', 'box the gnat'], ['figure', 'swat the flea']], dance)
      expect(figure_indicies).to eq([1])
    end

    it 'wraps' do
      dance = FactoryGirl.create(:dance)
      figure_indicies = DanceDatatable.matching_figures(['follows', ['figure', 'circle'], ['figure', 'swing']], dance)
      expect(figure_indicies).to eq([0])
    end

    it 'returns everything with zero arguments' do
      dance = FactoryGirl.create(:dance)
      figure_indicies = DanceDatatable.matching_figures(['follows'], dance)
      expect(figure_indicies).to eq([*(0...dance.figures.length)])
    end

    it 'returns index of figure with one argument' do
      dance = FactoryGirl.create(:dance)
      figure_indicies = DanceDatatable.matching_figures(['follows', ['figure', 'circle']], dance)
      expect(figure_indicies).to eq([4,6])
    end
  end

  describe '.hash_to_array' do
    it 'works' do
      h = {'faux_array' => true, "0" => 'figure', "1" => 'swing'}
      expect(DanceDatatable.send(:hash_to_array, h)).to eq(['figure', 'swing'])
    end

    it 'is recursive' do
      h = {'faux_array' => true, "0" => 'not', "1" => {'faux_array' => true, "0" => 'figure', "1" => 'swing'}}
      expect(DanceDatatable.send(:hash_to_array, h)).to eq(['not', ['figure', 'swing']])
    end

    it 'does not disturb hashes that do not have the faux_array key true' do
      h = {0 => 'chicken'}
      expect(DanceDatatable.send(:hash_to_array, h)).to eq(h)
    end

    it 'passes atoms undisturbed' do
      h = 42
      expect(DanceDatatable.send(:hash_to_array, h)).to eq(h)
    end

    # unspecified because I don't need it yet: 
    # what happens when you get a non faux_array and it has a faux_array as a key or value.
  end
end
