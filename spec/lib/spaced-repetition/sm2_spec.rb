require File.expand_path(File.dirname(__FILE__) + '../../../spec_helper')

describe SuperMemo::SM2 do
  
  describe 'include mixin' do

    it 'should work fine when including' do
      class Temp
        attr_accessor :easiness_factor, :number_repetitions, 
          :quality_of_last_recall, :next_repetition, :repetition_interval, :last_studied
        include SuperMemo::SM2
      end
      
      t = Temp.new
      t.check_spaced_repetition_methods
    end

    it 'should raise an exception if class including is missing fields' do
      class Temp2 
        include SuperMemo::SM2
      end
      t = Temp2.new

      lambda {
        t.check_spaced_repetition_methods
      }.should raise_error
    end

  end
  
  describe 'exclude mixin' do
    
    before :each do
      @card = OpenStruct.new(
      {
        :easiness_factor => nil, 
        :number_repetitions => nil, 
        :quality_of_last_recall => nil,
        :next_repetition => nil,
        :repetition_interval => nil,
        :last_studied => nil,
        :question => "Who is the most awesome of them all?",
        :answer => 'Me!'
      })

      @card.extend SuperMemo::SM2
      @card.reset_spaced_repetition_data
      
      Time.stub!(:now).and_return(Time.mktime(2010,1,1))
    end
    
    it 'should raise an exception if class extended is missing fields' do
      lambda { nil.extend SuperMemo::SM2 }.should raise_error
    end
    
    it 'should initialize values' do
      @card.easiness_factor.should == 2.5  
      @card.number_repetitions.should == 0  
      @card.repetition_interval.should == nil  
      @card.quality_of_last_recall.should == nil  
      @card.next_repetition.should == nil
      @card.last_studied.should == nil
    end
    
    it 'should schedule next repetition for tomorrow if repetition_interval = 0 and quality_of_last_recall = 4' do      
      @card.process_recall_result(4)
      
      @card.number_repetitions.should == 1
      @card.repetition_interval.should == 1
      @card.last_studied.should == Time.now
      @card.next_repetition.should == (Time.now + 1.day)
      @card.easiness_factor.should be_within(2.5).of(0.01)
    end

    it 'should schedule next repetition for 6 days if repetition_interval = 1 and quality_of_last_recall = 4' do
      @card.process_recall_result(4)
      @card.process_recall_result(4)
      
      @card.number_repetitions.should == 2
      @card.repetition_interval.should == 6
      @card.last_studied.should == Time.now
      @card.next_repetition.should == (Time.now + 6.days)
      @card.easiness_factor.should be_within(2.5).of(0.01)
    end
    
    it 'should report as scheduled to recall (for today)' do
      @card.next_repetition = Time.now
      @card.scheduled_to_recall?.should == true

      @card.next_repetition = Time.now - 1.day
      @card.scheduled_to_recall?.should == true
    end
    
    it 'should not be scheduled to recall' do
      @card.next_repetition = nil
      @card.scheduled_to_recall?.should == false

      @card.next_repetition = Time.now + 1.day
      @card.scheduled_to_recall?.should == false

      @card.next_repetition = Time.now + 99.day
      @card.scheduled_to_recall?.should == false
    end
    
    it 'should require repeating items that scored 3' do
      @card.process_recall_result(3)
      @card.next_repetition.should == Time.now

      @card.process_recall_result(3)
      @card.next_repetition.should == Time.now

      @card.process_recall_result(4)
      @card.next_repetition.should == Time.now + 1.day
    end
    
  end


end