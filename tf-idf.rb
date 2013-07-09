require 'csv'

class TextWeight
  #calculate the tf-idf for a set of text files and write it to a csv
  attr_accessor :tf, :df, :weights, :num_docs

  def initialize
    self.tf = Hash.new
    self.df = Hash.new
    self.weights = Hash.new
    self.num_docs = 0
  end 

  def parse_doc doc
    
    self.num_docs = self.num_docs + 1
    words = doc.split
    unique_words = words.uniq
    words.each do |w|
      if self.tf[w] != nil
        self.tf[w] = self.tf[w] + 1
      else
        self.tf[w] = 1
      end
    end
    
    unique_words.each do |w|
      if self.df[w] != nil
        self.df[w] = df[w] + 1
      else
        self.df[w] = 1
      end
    end


  end

  def calculate_weights
    
    self.tf.each do |key, value|
      self.weights[key] = value * Math.log(self.num_docs/self.df[key])
    end

  end

  def run directory
    
    Dir.glob(directory+"/*.txt") do |file|
      doc = ""
      File.open(file, 'r').lines do |line|
        doc = doc + line
      end
      parse_doc doc
    end

    calculate_weights

    w_file = CSV.open(directory+"/"+directory+"_weights.csv", 'w')
    self.weights = self.weights.sort_by{|k,v| v}
    self.weights.each do |key, value|
      w_file << [key, value] 
    end
    w_file.close
  
  end
  
end


