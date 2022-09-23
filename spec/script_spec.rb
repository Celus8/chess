# frozen_string_literal: true

require './script'
require './pieces'

# Separate between black and whites in tests. Write tests for a piece, create the class. First without any other piece around, and no castling and promoting. Then add functionality for playing.

RSpec.describe Pawn do
  context 'when there are no pieces around' do
    context 'when the pawn is white' do
      subject { described_class.new([3, 1], 1) }

      context "when it's in the initial position" do
        it 'is in the initial position' do
          expect(subject).to be_in_initial_pos
        end

        it 'can move two positions' do
          expect(subject.moves).to include([3, 3])
        end
      end

      it 'can move one position' do
        expect(subject.moves).to include([3, 2])
      end

      it "can't move backwards, sideways or diaognally" do
        expect(subject.moves).not_to include([3, 0], [2, 1], [4, 2], [2, 2])
      end
    end

    context 'when the pawn is black' do
      subject { described_class.new([3, 6], -1) }

      context "when it's in the initial position" do
        it 'is in the initial position' do
          expect(subject).to be_in_initial_pos
        end

        it 'can move two positions' do
          expect(subject.moves).to include([3, 4])
        end
      end

      it 'can move one position' do
        expect(subject.moves).to include([3, 5])
      end

      it "can't move backwards, sideways or diaognally" do
        expect(subject.moves).not_to include([3, 7], [2, 6], [4, 6], [2, 6])
      end
    end
  end
end

RSpec.describe King do
  context 'when there are no pieces around' do
    subject { described_class.new([3, 3]) }

    it 'can move in any direction once' do
      expect(subject.moves).to include([3, 4], [4, 4], [4, 3], [2, 2], [2, 3], [3, 2], [2, 4], [4, 2])
    end

    it "can't move more than once" do
      expect(subject.moves).not_to include([3, 5], [5, 3])
    end
  end
end

RSpec.describe Queen do
  context 'when there are no pieces around' do
    subject { described_class.new([3, 3]) }

    it 'can move in any direction as many times as she wants' do
      expect(subject.moves).to include([3, 7], [3, 0], [6, 6], [4, 3], [0, 0], [5, 3], [3, 2], [2, 4], [4, 2], [6, 0])
    end

    it "can't move in a not straight direction" do
      expect(subject.moves).not_to include([2, 5], [7, 2])
    end
  end
end

RSpec.describe Rook do
  context 'when there are no pieces around' do
    subject { described_class.new([3, 3]) }

    it 'can move as much as wanted horizontally and vertically' do
      expect(subject.moves).to include([3, 7], [3, 0], [6, 3], [4, 3], [0, 3], [5, 3], [3, 2], [3, 4])
    end

    it "can't move in a not straight direction" do
      expect(subject.moves).not_to include([2, 5], [7, 2])
    end

    it "can't move diagonally" do
      expect(subject.moves).not_to include([2, 2], [0, 0], [6, 0], [7, 7])
    end
  end
end

RSpec.describe Bishop do
  context 'when there are no pieces around' do
    subject { described_class.new([3, 3]) }

    it "can't move horizontally and vertically" do
      expect(subject.moves).not_to include([3, 7], [3, 0], [6, 3], [4, 3], [0, 3], [5, 3], [3, 2], [3, 4])
    end

    it "can't move in a not straight direction" do
      expect(subject.moves).not_to include([2, 5], [7, 2])
    end

    it 'can move as much as wanted diagonally' do
      expect(subject.moves).to include([2, 2], [0, 0], [6, 0], [7, 7], [1, 5])
    end
  end
end

RSpec.describe Knight do
  context 'when there are no pieces around' do
    subject { described_class.new([3, 3]) }

    it "can't move horizontally and vertically" do
      expect(subject.moves).not_to include([3, 7], [3, 0], [6, 3], [4, 3], [0, 3], [5, 3], [3, 2], [3, 4])
    end

    it "can't move diagonally" do
      expect(subject.moves).not_to include([2, 2], [0, 0], [6, 0], [7, 7], [1, 5])
    end

    it 'can move in knight jumps' do
      expect(subject.moves).to include([4, 5], [2, 5], [4, 1], [2, 1], [5, 2], [1, 2])
    end
  end
end
