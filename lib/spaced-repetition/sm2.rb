module SuperMemo  
  # This module can be used as a mixin to add the algorithms as used by 
  # SuperMemo 2 (typically referred to as SM2).  
  # 
  # See the README for more information.
  module SM2
    
    def SM2.extended(obj)
      obj.check_spaced_repetition_methods
    end
  
    def reset_spaced_repetition_data
      self.easiness_factor = 2.5
      self.number_repetitions = 0
      self.quality_of_last_recall = nil
      self.repetition_interval = nil
      self.next_repetition = nil
      self.last_studied = nil
    end

    def process_recall_result(quality_of_recall)
      raise "Quality of recall must be greater than zero" if quality_of_recall < 0
      raise "Quality of recall must be less than 5" if quality_of_recall > 5
      raise "Easiness Factor is not set" unless self.easiness_factor
      raise "Number of Repetitions is not set" unless self.number_repetitions
      
      if quality_of_recall < 3    
        self.number_repetitions = 0 
        self.repetition_interval = 0
      else
        self.easiness_factor = calculate_easiness_factor(easiness_factor, quality_of_recall)
      
        if quality_of_recall == 3
          self.repetition_interval = 0
        else
          self.number_repetitions += 1

          case number_repetitions
          when 1
            self.repetition_interval = 1
          when 2
            self.repetition_interval = 6
          else
            self.repetition_interval = repetition_interval * easiness_factor
          end
        end
      end
      self.quality_of_last_recall = quality_of_recall
      self.next_repetition = Time.now + repetition_interval.days
      self.last_studied = Time.now
    end

    def scheduled_to_recall?
      !next_repetition.nil? && next_repetition <= Time.now
    end

    def check_spaced_repetition_methods
      begin
        send(:easiness_factor)
        send(:number_repetitions)
        send(:quality_of_last_recall)
        send(:next_repetition)
        send(:repetition_interval)
        send(:last_studied)
      rescue NoMethodError => e
        raise "You did not set a required attr_accessor: " + e.message
      end
    end
    
    private 
    
    def calculate_easiness_factor(easiness_factor, quality_of_recall)
      q = quality_of_recall
      ef_old = easiness_factor

      result = ef_old - 0.8 + (0.28*q) - (0.02*q*q)
      result < 1.3 ? 1.3 : result
    end
    
  end
end
