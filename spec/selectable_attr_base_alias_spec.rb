# -*- coding: utf-8 -*-
require File.join(File.dirname(__FILE__), 'spec_helper')
require 'stringio'

describe SelectableAttr do

  def assert_enum_class_methods(klass, attr = :enum1)
    klass.send("#{attr}_enum").length.should == 3
    expected_hash_array = [
        {:id => 1, :key => :entry1, :name => "エントリ1"},
        {:id => 2, :key => :entry2, :name => "エントリ2"},
        {:id => 3, :key => :entry3, :name => "エントリ3"}
      ]
    klass.send("#{attr}_hash_array").should == expected_hash_array
    klass.send("#{attr}_enum").to_hash_array.should == expected_hash_array
    klass.send("#{attr}_entries").
      map{|entry| {:id => entry.id, :key => entry.key, :name => entry.name} }.
      should == expected_hash_array

    klass.send("#{attr}_ids").should == [1,2,3]
    klass.send("#{attr}_ids", :entry2, :entry3).should == [2,3]
    klass.send("#{attr}_keys").should == [:entry1, :entry2, :entry3]
    klass.send("#{attr}_keys", 1,3).should == [:entry1, :entry3]
    klass.send("#{attr}_names").should == ["エントリ1", "エントリ2", "エントリ3"]
    klass.send("#{attr}_names", 1,2).should == ["エントリ1", "エントリ2"]
    klass.send("#{attr}_names", :entry1, :entry2).should == ["エントリ1", "エントリ2"]
    klass.send("#{attr}_options").should == [['エントリ1', 1], ['エントリ2', 2], ['エントリ3', 3]]
    klass.send("#{attr}_options", :entry2, :entry3).should == [['エントリ2', 2], ['エントリ3', 3]]
    klass.send("#{attr}_options", 1,2).should == [['エントリ1', 1], ['エントリ2', 2]]

    klass.send("#{attr}_id_by_key", nil).should be_nil
    klass.send("#{attr}_id_by_key", :entry1).should == 1
    klass.send("#{attr}_id_by_key", :entry2).should == 2
    klass.send("#{attr}_id_by_key", :entry3).should == 3
    klass.send("#{attr}_name_by_key", nil).should be_nil
    klass.send("#{attr}_name_by_key", :entry1).should == "エントリ1"
    klass.send("#{attr}_name_by_key", :entry2).should == "エントリ2"
    klass.send("#{attr}_name_by_key", :entry3).should == "エントリ3"

    klass.send("#{attr}_key_by_id", nil).should be_nil
    klass.send("#{attr}_key_by_id", 1).should == :entry1
    klass.send("#{attr}_key_by_id", 2).should == :entry2
    klass.send("#{attr}_key_by_id", 3).should == :entry3
    klass.send("#{attr}_name_by_id", nil).should be_nil
    klass.send("#{attr}_name_by_id", 1).should == "エントリ1"
    klass.send("#{attr}_name_by_id", 2).should == "エントリ2"
    klass.send("#{attr}_name_by_id", 3).should == "エントリ3"
  end

  def assert_single_enum_instance_methods(obj, attr = :enum1)
    obj.send("#{attr}=", 1)
    obj.send(attr).should == 1
    obj.enum1_key.should == :entry1
    obj.enum1_name.should == "エントリ1"
    obj.enum1_entry.to_hash.should == {:id => 1, :key => :entry1, :name => "エントリ1"}

    obj.enum1_key = :entry2
    obj.send(attr).should == 2
    obj.enum1_key.should == :entry2
    obj.enum1_name.should == "エントリ2"
    obj.enum1_entry.to_hash.should == {:id => 2, :key => :entry2, :name => "エントリ2"}

    obj.send("#{attr}=", 3)
    obj.send(attr).should == 3
    obj.enum1_key.should == :entry3
    obj.enum1_name.should == "エントリ3"
    obj.enum1_entry.to_hash.should == {:id => 3, :key => :entry3, :name => "エントリ3"}
  end

  class EnumBase
    include ::SelectableAttr::Base
  end

  describe "selectable_attr with default" do
    class EnumMock1 < EnumBase
      selectable_attr :enum1, :default => 2 do
        entry 1, :entry1, "エントリ1"
        entry 2, :entry2, "エントリ2"
        entry 3, :entry3, "エントリ3"
      end
    end

    class EnumMock1WithEnum < EnumBase
      selectable_attr :enum1, :default => 2 do
        entry 1, :entry1, "エントリ1"
        entry 2, :entry2, "エントリ2"
        entry 3, :entry3, "エントリ3"
      end
    end

    it "test_selectable_attr1" do
      assert_enum_class_methods(EnumMock1)
      mock1 = EnumMock1.new
      mock1.enum1.should == 2
      assert_single_enum_instance_methods(mock1)

      assert_enum_class_methods(EnumMock1WithEnum)
      mock1 = EnumMock1WithEnum.new
      mock1.enum1.should == 2
      assert_single_enum_instance_methods(mock1)

      EnumMock1.selectable_attr_type_for(:enum1).should == :single
      EnumMock1WithEnum.selectable_attr_type_for(:enum1).should == :single
    end
  end


  describe "attr_enumeable_base" do
    class EnumMock2 < EnumBase
      attr_enumeable_base do |attr|
        attr.to_s.gsub(/(.*)_code(.*)$/){"#{$1}#{$2}"}
      end

      selectable_attr :enum_code1 do
        entry 1, :entry1, "エントリ1"
        entry 2, :entry2, "エントリ2"
        entry 3, :entry3, "エントリ3"
      end
    end

    class EnumMock2WithEnum < EnumBase
      attr_enumeable_base do |attr|
        attr.to_s.gsub(/(.*)_code(.*)$/){"#{$1}#{$2}"}
      end

      enum :enum_code1 do
        entry 1, :entry1, "エントリ1"
        entry 2, :entry2, "エントリ2"
        entry 3, :entry3, "エントリ3"
      end
    end

    it "test_selectable_attr2" do
      assert_enum_class_methods(EnumMock2)
      assert_single_enum_instance_methods(EnumMock2.new, :enum_code1)
      assert_enum_class_methods(EnumMock2WithEnum)
      assert_single_enum_instance_methods(EnumMock2WithEnum.new, :enum_code1)
    end
  end


  def assert_multi_enum_instance_methods(obj, patterns)
    obj.enum_array1_hash_array.should == [
        {:id => 1, :key => :entry1, :name => "エントリ1", :select => false},
        {:id => 2, :key => :entry2, :name => "エントリ2", :select => false},
        {:id => 3, :key => :entry3, :name => "エントリ3", :select => false}
      ]
    obj.enum_array1_selection.should == [false, false, false]
    obj.enum_array1.should be_nil
    obj.enum_array1_entries.should == []
    obj.enum_array1_keys.should == []
    obj.enum_array1_names.should == []

    obj.enum_array1 = patterns[0]
    obj.enum_array1.should == patterns[0]
    obj.enum_array1_hash_array.should == [
        {:id => 1, :key => :entry1, :name => "エントリ1", :select => false},
        {:id => 2, :key => :entry2, :name => "エントリ2", :select => false},
        {:id => 3, :key => :entry3, :name => "エントリ3", :select => false}
      ]
    obj.enum_array1_selection.should == [false, false, false]
    obj.enum_array1_entries.should == []
    obj.enum_array1_keys.should == []
    obj.enum_array1_names.should == []

    obj.enum_array1 = patterns[1]
    obj.enum_array1.should == patterns[1]
    obj.enum_array1_hash_array.should == [
        {:id => 1, :key => :entry1, :name => "エントリ1", :select => false},
        {:id => 2, :key => :entry2, :name => "エントリ2", :select => false},
        {:id => 3, :key => :entry3, :name => "エントリ3", :select => true}
      ]
    obj.enum_array1_selection.should == [false, false, true]
    obj.enum_array1_entries.map(&:id).should == [3]
    obj.enum_array1_keys.should == [:entry3]
    obj.enum_array1_names.should == ['エントリ3']

    obj.enum_array1 = patterns[3]
    obj.enum_array1.should == patterns[3]
    obj.enum_array1_hash_array.should == [
        {:id => 1, :key => :entry1, :name => "エントリ1", :select => false},
        {:id => 2, :key => :entry2, :name => "エントリ2", :select => true},
        {:id => 3, :key => :entry3, :name => "エントリ3", :select => true}
      ]
    obj.enum_array1_selection.should == [false, true, true]
    obj.enum_array1_entries.map(&:id).should == [2, 3]
    obj.enum_array1_keys.should == [:entry2, :entry3]
    obj.enum_array1_names.should == ['エントリ2', 'エントリ3']

    obj.enum_array1 = patterns[7]
    obj.enum_array1.should == patterns[7]
    obj.enum_array1_hash_array.should == [
        {:id => 1, :key => :entry1, :name => "エントリ1", :select => true},
        {:id => 2, :key => :entry2, :name => "エントリ2", :select => true},
        {:id => 3, :key => :entry3, :name => "エントリ3", :select => true}
      ]
    obj.enum_array1_selection.should == [true, true, true]
    obj.enum_array1_ids.should == [1, 2, 3]
    obj.enum_array1_entries.map(&:id).should == [1, 2, 3]
    obj.enum_array1_keys.should == [:entry1, :entry2, :entry3]
    obj.enum_array1_names.should == ['エントリ1', 'エントリ2', 'エントリ3']

    obj.enum_array1_ids = [1,3]; obj.enum_array1.should == patterns[5]
    obj.enum_array1_ids = [1,2]; obj.enum_array1.should == patterns[6]
    obj.enum_array1_ids = [2]; obj.enum_array1.should == patterns[2]

    obj.enum_array1_keys = [:entry1,:entry3]; obj.enum_array1.should == patterns[5]
    obj.enum_array1_keys = [:entry1,:entry2]; obj.enum_array1.should == patterns[6]
    obj.enum_array1_keys = [:entry2]; obj.enum_array1.should == patterns[2]

    obj.enum_array1_selection = [true, false, true]; obj.enum_array1.should == patterns[5]
    obj.enum_array1_selection = [true, true, false]; obj.enum_array1.should == patterns[6]
    obj.enum_array1_selection = [false, true, false]; obj.enum_array1.should == patterns[2]

    obj.enum_array1_ids = "1,3"; obj.enum_array1.should == patterns[5]
    obj.enum_array1_ids = "1,2"; obj.enum_array1.should == patterns[6]
    obj.enum_array1_ids = "2"; obj.enum_array1.should == patterns[2]
  end

  describe ":convert_with => :binary_string" do
    class EnumMock3 < EnumBase
      multi_selectable_attr :enum_array1, :convert_with => :binary_string do
        entry 1, :entry1, "エントリ1"
        entry 2, :entry2, "エントリ2"
        entry 3, :entry3, "エントリ3"
      end
    end

    class EnumMock3WithEnumArray < EnumBase
      enum_array :enum_array1, :convert_with => :binary_string do
        entry 1, :entry1, "エントリ1"
        entry 2, :entry2, "エントリ2"
        entry 3, :entry3, "エントリ3"
      end
    end

    it "test_multi_selectable_attr_with_binary_string" do
      expected = (0..7).map{|i| '%03b' % i} # ["000", "001", "010", "011", "100", "101", "110", "111"]
      assert_enum_class_methods(EnumMock3, :enum_array1)
      assert_multi_enum_instance_methods(EnumMock3.new, expected)
      assert_enum_class_methods(EnumMock3WithEnumArray, :enum_array1)
      assert_multi_enum_instance_methods(EnumMock3WithEnumArray.new, expected)
      EnumMock3.selectable_attr_type_for(:enum_array1).should == :multi
    end
  end

  describe "multi_selectable_attr" do
    class EnumMock4 < EnumBase
      multi_selectable_attr :enum_array1 do
        entry 1, :entry1, "エントリ1"
        entry 2, :entry2, "エントリ2"
        entry 3, :entry3, "エントリ3"
      end
    end

    class EnumMock4WithEnumArray < EnumBase
      enum_array :enum_array1 do
        entry 1, :entry1, "エントリ1"
        entry 2, :entry2, "エントリ2"
        entry 3, :entry3, "エントリ3"
      end
    end

    it "test_multi_selectable_attr2" do
      # [[], [3], [2], [2, 3], [1], [1, 3], [1, 2], [1, 2, 3]]
      expected =
        (0..7).map do |i|
          s = '%03b' % i
          a = s.split('').map{|v| v.to_i}
          ret = []
          a.each_with_index{|val, pos| ret << pos + 1 if val == 1}
          ret
        end
      assert_enum_class_methods(EnumMock4, :enum_array1)
      assert_multi_enum_instance_methods(EnumMock4.new, expected)
      assert_enum_class_methods(EnumMock4WithEnumArray, :enum_array1)
      assert_multi_enum_instance_methods(EnumMock4WithEnumArray.new, expected)
    end
  end

  describe "convert_with" do
    class EnumMock5 < EnumBase
      multi_selectable_attr :enum_array1, :convert_with => :comma_string do
        entry 1, :entry1, "エントリ1"
        entry 2, :entry2, "エントリ2"
        entry 3, :entry3, "エントリ3"
      end
    end

    class EnumMock5WithEnumArray < EnumBase
      enum_array :enum_array1, :convert_with => :comma_string do
        entry 1, :entry1, "エントリ1"
        entry 2, :entry2, "エントリ2"
        entry 3, :entry3, "エントリ3"
      end
    end

    it "test_multi_selectable_attr_with_comma_string" do
      # ["", "3", "2", "2,3", "1", "1,3", "1,2", "1,2,3"]
      expected =
        (0..7).map do |i|
          s = '%03b' % i
          a = s.split('').map{|v| v.to_i}
          ret = []
          a.each_with_index{|val, pos| ret << pos + 1 if val == 1}
          ret.join(',')
        end
      assert_enum_class_methods(EnumMock5, :enum_array1)
      assert_multi_enum_instance_methods(EnumMock5.new, expected)
      assert_enum_class_methods(EnumMock5WithEnumArray, :enum_array1)
      assert_multi_enum_instance_methods(EnumMock5WithEnumArray.new, expected)
    end
  end

  describe "selectable_attr_name_pattern" do
    class EnumMock6 < EnumBase
      # self.selectable_attr_name_pattern = /(_cd$|_code$|_cds$|_codes$)/
      selectable_attr :category_id do
        entry "01", :category1, "カテゴリ1"
        entry "02", :category2, "カテゴリ2"
      end
    end

    class EnumMock7 < EnumBase
      self.selectable_attr_name_pattern = /(_cd$|_id$|_cds$|_ids$)/
      selectable_attr :category_id do
        entry "01", :category1, "カテゴリ1"
        entry "02", :category2, "カテゴリ2"
      end
    end

    it "test_selectable_attr_name_pattern" do
      EnumMock6.selectable_attr_name_pattern.should == /(_cd$|_code$|_cds$|_codes$)/
      EnumMock6.respond_to?(:category_enum).should == false
      EnumMock6.respond_to?(:category_id_enum).should == true
      EnumMock6.new.respond_to?(:category_key).should == false
      EnumMock6.new.respond_to?(:category_id_key).should == true

      EnumMock7.selectable_attr_name_pattern.should == /(_cd$|_id$|_cds$|_ids$)/
      EnumMock7.respond_to?(:category_enum).should == true
      EnumMock7.respond_to?(:category_id_enum).should == false
      EnumMock7.new.respond_to?(:category_key).should == true
      EnumMock7.new.respond_to?(:category_id_key).should == false
    end
  end

  describe "has_attr" do
    class ConnectableMock1 < EnumBase
      class << self
        def columns; end
        def connection; end
        def connectec?; end
        def table_exists?; end
      end
    end

    it "should return false if column does exist" do
      ConnectableMock1.should_receive(:connected?).and_return(true)
      ConnectableMock1.should_receive(:table_exists?).and_return(true)
      ConnectableMock1.should_receive(:columns).and_return([mock(:column1, :name => :column1)])
      ConnectableMock1.has_attr(:column1).should == true
    end

    it "should return false if column doesn't exist" do
      ConnectableMock1.should_receive(:connected?).and_return(true)
      ConnectableMock1.should_receive(:table_exists?).and_return(true)
      ConnectableMock1.should_receive(:columns).and_return([mock(:column1, :name => :column1)])
      ConnectableMock1.has_attr(:unknown_column).should == false
    end

    it "should return nil unless connected" do
      ConnectableMock1.should_receive(:connected?).and_return(false)
      ConnectableMock1.should_receive(:table_exists?).and_return(false)
      ConnectableMock1.has_attr(:unknown_column).should == false
    end

    it "should return nil if can't connection cause of Exception" do
      ConnectableMock1.should_receive(:connected?).twice.and_return(false)
      ConnectableMock1.should_receive(:connection).and_raise(IOError.new("can't connect to DB"))
      ConnectableMock1.has_attr(:unknown_column).should == nil
    end
  end

  describe "enum_for" do
    class EnumMock10 < EnumBase
      selectable_attr :enum1, :default => 2 do
        entry 1, :entry1, "エントリ1"
        entry 2, :entry2, "エントリ2"
        entry 3, :entry3, "エントリ3"
      end
    end

    it "return constant by Symbol access" do
      enum1 = EnumMock10.enum_for(:enum1)
      enum1.class.should == SelectableAttr::Enum
    end

    it "return constant by String access" do
      enum1 = EnumMock10.enum_for('enum1')
      enum1.class.should == SelectableAttr::Enum
    end

    it "return nil for unexist attr" do
      enum1 = EnumMock10.enum_for('unexist_attr')
      enum1.should == nil
    end

  end

  describe "define_accessor" do
    class DefiningMock1 < EnumBase
      class << self
        def attr_accessor_with_default(*args); end
      end
    end

    it "should call attr_accessor_with_default when both of attr_accessor and default are given" do
      DefiningMock1.should_receive(:attr_accessor_with_default).with(:enum1, 1)
      DefiningMock1.define_accessor(:attr => :enum1, :attr_accessor => true, :default => 1)
    end

    it "should call attr_accessor_with_default when default are given but attr_accessor is not TRUE" do
      SelectableAttr.logger.should_receive(:warn).with(":default option ignored for enum1")
      DefiningMock1.define_accessor(:attr => :enum1, :attr_accessor => false, :default => 1)
    end

    it "warning message to logger" do
      io = StringIO.new
      SelectableAttr.logger = Logger.new(io)
      DefiningMock1.define_accessor(:attr => :enum1, :attr_accessor => false, :default => 1)
      io.rewind
      io.read.should =~ /WARN -- : :default option ignored for enum1$/
    end


  end


end
