require 'rails_helper'

RSpec.describe TuringQuestion, type: :model do
  before do
    @configured_sets = TURING_QUESTIONS["en"]
  end

  it "returns a random set" do
    t1 = TuringQuestion.random
    t2 = TuringQuestion.random
    t3 = TuringQuestion.random
    t4 = TuringQuestion.random
    t5 = TuringQuestion.random
    # Five times the same set is unlikely enough.
    expect(t1.id * 5).to_not eql(t1.id + t2.id + t3.id + t4.id + t5.id)
  end

  it "finds a specific set" do
    t = TuringQuestion.find(0)
    expect(t.id).to be(0)
    expect(t.question).to eql(@configured_sets.first["question"])
  end

  it { is_expected.to respond_to :valid_answer? }

  it "accepts a valid answer as valid" do
    turing_question = TuringQuestion.find(0)
    answer = @configured_sets.first["answers"].first
    expect(turing_question.valid_answer?(answer)).to be(true)
  end
end
