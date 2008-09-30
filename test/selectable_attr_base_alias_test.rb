# -*- coding: utf-8 -*-
require File.join(File.dirname(__FILE__), 'test_helper')

class SelectableAttrBaseTest < Test::Unit::TestCase

  class EnumBase
    include ::SelectableAttr::Base
  end

  class EnumMock1 < EnumBase
    selectable_attr :enum1, :default => 2 do
      entry 1, :entry1, "エントリ1"
      entry 2, :entry2, "エントリ2"
      entry 3, :entry3, "エントリ3"
    end
  end

  def test_selectable_attr1
    assert_equal(3, EnumMock1.enum1_enum.length)
    expected_hash_array = [
        {:id => 1, :key => :entry1, :name => "エントリ1"},
        {:id => 2, :key => :entry2, :name => "エントリ2"},
        {:id => 3, :key => :entry3, :name => "エントリ3"}
      ]
    assert_equal(expected_hash_array, EnumMock1.enum1_hash_array)
    assert_equal(expected_hash_array, EnumMock1.enum1_enum.to_hash_array)
    assert_equal(expected_hash_array, 
      EnumMock1.enum1_entries.map{|entry| {:id => entry.id, :key => entry.key, :name => entry.name} })

    assert_equal([1,2,3], EnumMock1.enum1_ids)
    assert_equal([2,3], EnumMock1.enum1_ids(:entry2, :entry3))
    assert_equal([:entry1, :entry2, :entry3], EnumMock1.enum1_keys)
    assert_equal([:entry1, :entry3], EnumMock1.enum1_keys(1,3))
    assert_equal(["エントリ1", "エントリ2", "エントリ3"], EnumMock1.enum1_names)
    assert_equal(["エントリ1", "エントリ2"], EnumMock1.enum1_names(1,2))
    assert_equal(["エントリ1", "エントリ2"], EnumMock1.enum1_names(:entry1, :entry2))
    assert_equal([['エントリ1', 1], ['エントリ2', 2], ['エントリ3', 3]], EnumMock1.enum1_options)
    assert_equal([['エントリ2', 2], ['エントリ3', 3]], EnumMock1.enum1_options(:entry2, :entry3))
    assert_equal([['エントリ1', 1], ['エントリ2', 2]], EnumMock1.enum1_options(1,2))

    assert_equal(nil, EnumMock1.enum1_id_by_key(nil))
    assert_equal(1, EnumMock1.enum1_id_by_key(:entry1))
    assert_equal(2, EnumMock1.enum1_id_by_key(:entry2))
    assert_equal(3, EnumMock1.enum1_id_by_key(:entry3))
    assert_equal(nil, EnumMock1.enum1_name_by_key(nil))
    assert_equal("エントリ1", EnumMock1.enum1_name_by_key(:entry1))
    assert_equal("エントリ2", EnumMock1.enum1_name_by_key(:entry2))
    assert_equal("エントリ3", EnumMock1.enum1_name_by_key(:entry3))

    assert_equal(nil, EnumMock1.enum1_key_by_id(nil))
    assert_equal(:entry1, EnumMock1.enum1_key_by_id(1))
    assert_equal(:entry2, EnumMock1.enum1_key_by_id(2))
    assert_equal(:entry3, EnumMock1.enum1_key_by_id(3))
    assert_equal(nil, EnumMock1.enum1_name_by_id(nil))
    assert_equal("エントリ1", EnumMock1.enum1_name_by_id(1))
    assert_equal("エントリ2", EnumMock1.enum1_name_by_id(2))
    assert_equal("エントリ3", EnumMock1.enum1_name_by_id(3))
    
    mock1 = EnumMock1.new
    assert_equal 2, mock1.enum1
    mock1.enum1 = 1
    assert_equal 1, mock1.enum1
    assert_equal :entry1, mock1.enum1_key
    assert_equal "エントリ1", mock1.enum1_name
    assert_equal({:id => 1, :key => :entry1, :name => "エントリ1"}, mock1.enum1_entry.to_hash)
    
    mock1.enum1_key = :entry2
    assert_equal 2, mock1.enum1
    assert_equal :entry2, mock1.enum1_key
    assert_equal "エントリ2", mock1.enum1_name
    assert_equal({:id => 2, :key => :entry2, :name => "エントリ2"}, mock1.enum1_entry.to_hash)
    
    mock1.enum1 = 3
    assert_equal 3, mock1.enum1
    assert_equal :entry3, mock1.enum1_key
    assert_equal "エントリ3", mock1.enum1_name
    assert_equal({:id => 3, :key => :entry3, :name => "エントリ3"}, mock1.enum1_entry.to_hash)
  end

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

  def test_selectable_attr2
    assert_equal(3, EnumMock2.enum1_enum.length)
    expected_hash_array = [
        {:id => 1, :key => :entry1, :name => "エントリ1"},
        {:id => 2, :key => :entry2, :name => "エントリ2"},
        {:id => 3, :key => :entry3, :name => "エントリ3"}
      ]
    assert_equal(expected_hash_array, EnumMock2.enum1_hash_array)
    assert_equal(expected_hash_array, EnumMock2.enum1_enum.to_hash_array)
    assert_equal(expected_hash_array, 
      EnumMock2.enum1_entries.map{|entry| {:id => entry.id, :key => entry.key, :name => entry.name} })

    assert_equal([1,2,3], EnumMock2.enum1_ids)
    assert_equal([2,3], EnumMock2.enum1_ids(:entry2, :entry3))
    assert_equal([:entry1, :entry2, :entry3], EnumMock2.enum1_keys)
    assert_equal([:entry1, :entry3], EnumMock2.enum1_keys(1,3))
    assert_equal(["エントリ1", "エントリ2", "エントリ3"], EnumMock2.enum1_names)
    assert_equal(["エントリ1", "エントリ2"], EnumMock2.enum1_names(1,2))
    assert_equal(["エントリ1", "エントリ2"], EnumMock2.enum1_names(:entry1, :entry2))
    assert_equal([['エントリ1', 1], ['エントリ2', 2], ['エントリ3', 3]], EnumMock2.enum1_options)
    assert_equal([['エントリ2', 2], ['エントリ3', 3]], EnumMock2.enum1_options(:entry2, :entry3))
    assert_equal([['エントリ1', 1], ['エントリ2', 2]], EnumMock2.enum1_options(1,2))

    assert_equal(nil, EnumMock2.enum1_id_by_key(nil))
    assert_equal(1, EnumMock2.enum1_id_by_key(:entry1))
    assert_equal(2, EnumMock2.enum1_id_by_key(:entry2))
    assert_equal(3, EnumMock2.enum1_id_by_key(:entry3))
    assert_equal(nil, EnumMock2.enum1_name_by_key(nil))
    assert_equal("エントリ1", EnumMock2.enum1_name_by_key(:entry1))
    assert_equal("エントリ2", EnumMock2.enum1_name_by_key(:entry2))
    assert_equal("エントリ3", EnumMock2.enum1_name_by_key(:entry3))

    assert_equal(nil, EnumMock2.enum1_key_by_id(nil))
    assert_equal(:entry1, EnumMock2.enum1_key_by_id(1))
    assert_equal(:entry2, EnumMock2.enum1_key_by_id(2))
    assert_equal(:entry3, EnumMock2.enum1_key_by_id(3))
    assert_equal(nil, EnumMock2.enum1_name_by_id(nil))
    assert_equal("エントリ1", EnumMock2.enum1_name_by_id(1))
    assert_equal("エントリ2", EnumMock2.enum1_name_by_id(2))
    assert_equal("エントリ3", EnumMock2.enum1_name_by_id(3))
    
    mock2 = EnumMock2.new
    mock2.enum_code1 = 1
    assert_equal 1, mock2.enum_code1
    assert_equal :entry1, mock2.enum1_key
    assert_equal "エントリ1", mock2.enum1_name
    assert_equal({:id => 1, :key => :entry1, :name => "エントリ1"}, mock2.enum1_entry.to_hash)
    
    mock2.enum1_key = :entry2
    assert_equal 2, mock2.enum_code1
    assert_equal :entry2, mock2.enum1_key
    assert_equal "エントリ2", mock2.enum1_name
    assert_equal({:id => 2, :key => :entry2, :name => "エントリ2"}, mock2.enum1_entry.to_hash)
    
    mock2.enum_code1 = 3
    assert_equal 3, mock2.enum_code1
    assert_equal :entry3, mock2.enum1_key
    assert_equal "エントリ3", mock2.enum1_name
    assert_equal({:id => 3, :key => :entry3, :name => "エントリ3"}, mock2.enum1_entry.to_hash)
  end

  class EnumMock3 < EnumBase
    multi_selectable_attr :enum_array1, :convert_with => :binary_string do
      entry 1, :entry1, "エントリ1"
      entry 2, :entry2, "エントリ2"
      entry 3, :entry3, "エントリ3"
    end
  end
  
  def test_multi_selectable_attr_with_binary_string
    assert_equal(3, EnumMock3.enum_array1_enum.length)
    expected_hash_array = [
        {:id => 1, :key => :entry1, :name => "エントリ1"},
        {:id => 2, :key => :entry2, :name => "エントリ2"},
        {:id => 3, :key => :entry3, :name => "エントリ3"}
      ]
    assert_equal(expected_hash_array, EnumMock3.enum_array1_hash_array)
    assert_equal(expected_hash_array, EnumMock3.enum_array1_enum.to_hash_array)
    assert_equal(expected_hash_array, 
      EnumMock3.enum_array1_entries.map{|entry| {:id => entry.id, :key => entry.key, :name => entry.name} })
    
    assert_equal([1,2,3], EnumMock3.enum_array1_ids)
    assert_equal([2,3], EnumMock3.enum_array1_ids(:entry2, :entry3))
    assert_equal([:entry1, :entry2, :entry3], EnumMock3.enum_array1_keys)
    assert_equal([:entry1, :entry3], EnumMock3.enum_array1_keys(1,3))
    assert_equal(["エントリ1", "エントリ2", "エントリ3"], EnumMock3.enum_array1_names)
    assert_equal(["エントリ1", "エントリ2"], EnumMock3.enum_array1_names(1,2))
    assert_equal(["エントリ1", "エントリ2"], EnumMock3.enum_array1_names(:entry1, :entry2))
    assert_equal([['エントリ1', 1], ['エントリ2', 2], ['エントリ3', 3]], EnumMock3.enum_array1_options)
    assert_equal([['エントリ2', 2], ['エントリ3', 3]], EnumMock3.enum_array1_options(:entry2, :entry3))
    assert_equal([['エントリ1', 1], ['エントリ2', 2]], EnumMock3.enum_array1_options(1,2))

    assert_equal(nil, EnumMock3.enum_array1_id_by_key(nil))
    assert_equal(1, EnumMock3.enum_array1_id_by_key(:entry1))
    assert_equal(2, EnumMock3.enum_array1_id_by_key(:entry2))
    assert_equal(3, EnumMock3.enum_array1_id_by_key(:entry3))
    assert_equal(nil, EnumMock3.enum_array1_name_by_key(nil))
    assert_equal("エントリ1", EnumMock3.enum_array1_name_by_key(:entry1))
    assert_equal("エントリ2", EnumMock3.enum_array1_name_by_key(:entry2))
    assert_equal("エントリ3", EnumMock3.enum_array1_name_by_key(:entry3))

    assert_equal(nil, EnumMock3.enum_array1_key_by_id(nil))
    assert_equal(:entry1, EnumMock3.enum_array1_key_by_id(1))
    assert_equal(:entry2, EnumMock3.enum_array1_key_by_id(2))
    assert_equal(:entry3, EnumMock3.enum_array1_key_by_id(3))
    assert_equal(nil, EnumMock3.enum_array1_name_by_id(nil))
    assert_equal("エントリ1", EnumMock3.enum_array1_name_by_id(1))
    assert_equal("エントリ2", EnumMock3.enum_array1_name_by_id(2))
    assert_equal("エントリ3", EnumMock3.enum_array1_name_by_id(3))
    
    mock3 = EnumMock3.new
    assert_equal([
        {:id => 1, :key => :entry1, :name => "エントリ1", :select => false},
        {:id => 2, :key => :entry2, :name => "エントリ2", :select => false},
        {:id => 3, :key => :entry3, :name => "エントリ3", :select => false}
      ], mock3.enum_array1_hash_array)
    assert_equal([false, false, false], mock3.enum_array1_selection)
    assert_equal(nil, mock3.enum_array1)
    assert_equal([], mock3.enum_array1_entries)
    assert_equal([], mock3.enum_array1_keys)
    assert_equal([], mock3.enum_array1_names)
    
    mock3.enum_array1 = '000'
    assert_equal([
        {:id => 1, :key => :entry1, :name => "エントリ1", :select => false},
        {:id => 2, :key => :entry2, :name => "エントリ2", :select => false},
        {:id => 3, :key => :entry3, :name => "エントリ3", :select => false}
      ], mock3.enum_array1_hash_array)
    assert_equal([false, false, false], mock3.enum_array1_selection)
    assert_equal("000", mock3.enum_array1)
    assert_equal([], mock3.enum_array1_entries)
    assert_equal([], mock3.enum_array1_keys)
    assert_equal([], mock3.enum_array1_names)

    mock3.enum_array1 = '001'
    assert_equal([
        {:id => 1, :key => :entry1, :name => "エントリ1", :select => false},
        {:id => 2, :key => :entry2, :name => "エントリ2", :select => false},
        {:id => 3, :key => :entry3, :name => "エントリ3", :select => true}
      ], mock3.enum_array1_hash_array)
    assert_equal([false, false, true], mock3.enum_array1_selection)
    assert_equal("001", mock3.enum_array1)
    assert_equal([3], mock3.enum_array1_entries.map(&:id))
    assert_equal([:entry3], mock3.enum_array1_keys)
    assert_equal(['エントリ3'], mock3.enum_array1_names)
    
    mock3.enum_array1 = '011'
    assert_equal([
        {:id => 1, :key => :entry1, :name => "エントリ1", :select => false},
        {:id => 2, :key => :entry2, :name => "エントリ2", :select => true},
        {:id => 3, :key => :entry3, :name => "エントリ3", :select => true}
      ], mock3.enum_array1_hash_array)
    assert_equal([false, true, true], mock3.enum_array1_selection)
    assert_equal("011", mock3.enum_array1)
    assert_equal([2, 3], mock3.enum_array1_entries.map(&:id))
    assert_equal([:entry2, :entry3], mock3.enum_array1_keys)
    assert_equal(['エントリ2', 'エントリ3'], mock3.enum_array1_names)

    mock3.enum_array1 = '111'
    assert_equal([
        {:id => 1, :key => :entry1, :name => "エントリ1", :select => true},
        {:id => 2, :key => :entry2, :name => "エントリ2", :select => true},
        {:id => 3, :key => :entry3, :name => "エントリ3", :select => true}
      ], mock3.enum_array1_hash_array)
    assert_equal([true, true, true], mock3.enum_array1_selection)
    assert_equal([1, 2, 3], mock3.enum_array1_ids)
    assert_equal([1, 2, 3], mock3.enum_array1_entries.map(&:id))
    assert_equal([:entry1, :entry2, :entry3], mock3.enum_array1_keys)
    assert_equal(['エントリ1', 'エントリ2', 'エントリ3'], mock3.enum_array1_names)
    
    mock3.enum_array1_ids = [1,3]; assert_equal('101', mock3.enum_array1)
    mock3.enum_array1_ids = [1,2]; assert_equal('110', mock3.enum_array1)
    mock3.enum_array1_ids = [2]; assert_equal('010', mock3.enum_array1)

    mock3.enum_array1_keys = [:entry1,:entry3]; assert_equal('101', mock3.enum_array1)
    mock3.enum_array1_keys = [:entry1,:entry2]; assert_equal('110', mock3.enum_array1)
    mock3.enum_array1_keys = [:entry2]; assert_equal('010', mock3.enum_array1)

    mock3.enum_array1_selection = [true, false, true]; assert_equal('101', mock3.enum_array1)
    mock3.enum_array1_selection = [true, true, false]; assert_equal('110', mock3.enum_array1)
    mock3.enum_array1_selection = [false, true, false]; assert_equal('010', mock3.enum_array1)

    mock3.enum_array1_ids = "1,3"; assert_equal('101', mock3.enum_array1)
    mock3.enum_array1_ids = "1,2"; assert_equal('110', mock3.enum_array1)
    mock3.enum_array1_ids = "2"; assert_equal('010', mock3.enum_array1)
  end

  class EnumMock4 < EnumBase
    multi_selectable_attr :enum_array1 do
      entry 1, :entry1, "エントリ1"
      entry 2, :entry2, "エントリ2"
      entry 3, :entry3, "エントリ3"
    end
  end
  
  def test_multi_selectable_attr2
    assert_equal(3, EnumMock4.enum_array1_enum.length)
    expected_hash_array = [
        {:id => 1, :key => :entry1, :name => "エントリ1"},
        {:id => 2, :key => :entry2, :name => "エントリ2"},
        {:id => 3, :key => :entry3, :name => "エントリ3"}
      ]
    assert_equal(expected_hash_array, EnumMock4.enum_array1_hash_array)
    assert_equal(expected_hash_array, EnumMock4.enum_array1_enum.to_hash_array)
    assert_equal(expected_hash_array, 
      EnumMock4.enum_array1_entries.map{|entry| {:id => entry.id, :key => entry.key, :name => entry.name} })
    
    assert_equal([1,2,3], EnumMock4.enum_array1_ids)
    assert_equal([2,3], EnumMock4.enum_array1_ids(:entry2, :entry3))
    assert_equal([:entry1, :entry2, :entry3], EnumMock4.enum_array1_keys)
    assert_equal([:entry1, :entry3], EnumMock4.enum_array1_keys(1,3))
    assert_equal(["エントリ1", "エントリ2", "エントリ3"], EnumMock4.enum_array1_names)
    assert_equal(["エントリ1", "エントリ2"], EnumMock4.enum_array1_names(1,2))
    assert_equal(["エントリ1", "エントリ2"], EnumMock4.enum_array1_names(:entry1, :entry2))
    assert_equal([['エントリ1', 1], ['エントリ2', 2], ['エントリ3', 3]], EnumMock4.enum_array1_options)
    assert_equal([['エントリ2', 2], ['エントリ3', 3]], EnumMock4.enum_array1_options(:entry2, :entry3))
    assert_equal([['エントリ1', 1], ['エントリ2', 2]], EnumMock4.enum_array1_options(1,2))

    assert_equal(nil, EnumMock4.enum_array1_id_by_key(nil))
    assert_equal(1, EnumMock4.enum_array1_id_by_key(:entry1))
    assert_equal(2, EnumMock4.enum_array1_id_by_key(:entry2))
    assert_equal(3, EnumMock4.enum_array1_id_by_key(:entry3))
    assert_equal(nil, EnumMock4.enum_array1_name_by_key(nil))
    assert_equal("エントリ1", EnumMock4.enum_array1_name_by_key(:entry1))
    assert_equal("エントリ2", EnumMock4.enum_array1_name_by_key(:entry2))
    assert_equal("エントリ3", EnumMock4.enum_array1_name_by_key(:entry3))

    assert_equal(nil, EnumMock4.enum_array1_key_by_id(nil))
    assert_equal(:entry1, EnumMock4.enum_array1_key_by_id(1))
    assert_equal(:entry2, EnumMock4.enum_array1_key_by_id(2))
    assert_equal(:entry3, EnumMock4.enum_array1_key_by_id(3))
    assert_equal(nil, EnumMock4.enum_array1_name_by_id(nil))
    assert_equal("エントリ1", EnumMock4.enum_array1_name_by_id(1))
    assert_equal("エントリ2", EnumMock4.enum_array1_name_by_id(2))
    assert_equal("エントリ3", EnumMock4.enum_array1_name_by_id(3))
    
    mock4 = EnumMock4.new
    assert_equal([
        {:id => 1, :key => :entry1, :name => "エントリ1", :select => false},
        {:id => 2, :key => :entry2, :name => "エントリ2", :select => false},
        {:id => 3, :key => :entry3, :name => "エントリ3", :select => false}
      ], mock4.enum_array1_hash_array)
    assert_equal([false, false, false], mock4.enum_array1_selection)
    assert_equal(nil, mock4.enum_array1)
    assert_equal([], mock4.enum_array1_entries)
    assert_equal([], mock4.enum_array1_keys)
    assert_equal([], mock4.enum_array1_names)
    
    mock4.enum_array1 = '000'
    assert_equal([
        {:id => 1, :key => :entry1, :name => "エントリ1", :select => false},
        {:id => 2, :key => :entry2, :name => "エントリ2", :select => false},
        {:id => 3, :key => :entry3, :name => "エントリ3", :select => false}
      ], mock4.enum_array1_hash_array)
    assert_equal([false, false, false], mock4.enum_array1_selection)
    assert_equal('000', mock4.enum_array1)
    assert_equal([], mock4.enum_array1_entries)
    assert_equal([], mock4.enum_array1_keys)
    assert_equal([], mock4.enum_array1_names)

    mock4.enum_array1 = [3]
    assert_equal([
        {:id => 1, :key => :entry1, :name => "エントリ1", :select => false},
        {:id => 2, :key => :entry2, :name => "エントリ2", :select => false},
        {:id => 3, :key => :entry3, :name => "エントリ3", :select => true}
      ], mock4.enum_array1_hash_array)
    assert_equal([false, false, true], mock4.enum_array1_selection)
    assert_equal([3], mock4.enum_array1)
    assert_equal([3], mock4.enum_array1_entries.map(&:id))
    assert_equal([:entry3], mock4.enum_array1_keys)
    assert_equal(['エントリ3'], mock4.enum_array1_names)
    
    mock4.enum_array1 = [2,3]
    assert_equal([
        {:id => 1, :key => :entry1, :name => "エントリ1", :select => false},
        {:id => 2, :key => :entry2, :name => "エントリ2", :select => true},
        {:id => 3, :key => :entry3, :name => "エントリ3", :select => true}
      ], mock4.enum_array1_hash_array)
    assert_equal([false, true, true], mock4.enum_array1_selection)
    assert_equal([2, 3], mock4.enum_array1)
    assert_equal([2, 3], mock4.enum_array1_entries.map(&:id))
    assert_equal([:entry2, :entry3], mock4.enum_array1_keys)
    assert_equal(['エントリ2', 'エントリ3'], mock4.enum_array1_names)

    mock4.enum_array1 = [1,2,3]
    assert_equal([
        {:id => 1, :key => :entry1, :name => "エントリ1", :select => true},
        {:id => 2, :key => :entry2, :name => "エントリ2", :select => true},
        {:id => 3, :key => :entry3, :name => "エントリ3", :select => true}
      ], mock4.enum_array1_hash_array)
    assert_equal([true, true, true], mock4.enum_array1_selection)
    assert_equal([1, 2, 3], mock4.enum_array1_ids)
    assert_equal([1, 2, 3], mock4.enum_array1_entries.map(&:id))
    assert_equal([:entry1, :entry2, :entry3], mock4.enum_array1_keys)
    assert_equal(['エントリ1', 'エントリ2', 'エントリ3'], mock4.enum_array1_names)
    
    mock4.enum_array1_ids = [1,3]; assert_equal([1,3], mock4.enum_array1)
    mock4.enum_array1_ids = [1,2]; assert_equal([1,2], mock4.enum_array1)
    mock4.enum_array1_ids = [2]; assert_equal([2], mock4.enum_array1)

    mock4.enum_array1_keys = [:entry1,:entry3]; assert_equal([1,3], mock4.enum_array1)
    mock4.enum_array1_keys = [:entry1,:entry2]; assert_equal([1,2], mock4.enum_array1)
    mock4.enum_array1_keys = [:entry2]; assert_equal([2], mock4.enum_array1)

    mock4.enum_array1_selection = [true, false, true]; assert_equal([1,3], mock4.enum_array1)
    mock4.enum_array1_selection = [true, true, false]; assert_equal([1,2], mock4.enum_array1)
    mock4.enum_array1_selection = [false, true, false]; assert_equal([2], mock4.enum_array1)

    mock4.enum_array1_ids = "1,3"; assert_equal([1,3], mock4.enum_array1)
    mock4.enum_array1_ids = "1,2"; assert_equal([1,2], mock4.enum_array1)
    mock4.enum_array1_ids = "2"; assert_equal([2], mock4.enum_array1)
  end
  



  class EnumMock5 < EnumBase
    multi_selectable_attr :enum_array1, :convert_with => :comma_string do
      entry 1, :entry1, "エントリ1"
      entry 2, :entry2, "エントリ2"
      entry 3, :entry3, "エントリ3"
    end
  end
  
  def test_multi_selectable_attr_with_comma_string
    assert_equal(3, EnumMock5.enum_array1_enum.length)
    expected_hash_array = [
        {:id => 1, :key => :entry1, :name => "エントリ1"},
        {:id => 2, :key => :entry2, :name => "エントリ2"},
        {:id => 3, :key => :entry3, :name => "エントリ3"}
      ]
    assert_equal(expected_hash_array, EnumMock5.enum_array1_hash_array)
    assert_equal(expected_hash_array, EnumMock5.enum_array1_enum.to_hash_array)
    assert_equal(expected_hash_array, 
      EnumMock5.enum_array1_entries.map{|entry| {:id => entry.id, :key => entry.key, :name => entry.name} })
    
    assert_equal([1,2,3], EnumMock5.enum_array1_ids)
    assert_equal([2,3], EnumMock5.enum_array1_ids(:entry2, :entry3))
    assert_equal([:entry1, :entry2, :entry3], EnumMock5.enum_array1_keys)
    assert_equal([:entry1, :entry3], EnumMock5.enum_array1_keys(1,3))
    assert_equal(["エントリ1", "エントリ2", "エントリ3"], EnumMock5.enum_array1_names)
    assert_equal(["エントリ1", "エントリ2"], EnumMock5.enum_array1_names(1,2))
    assert_equal(["エントリ1", "エントリ2"], EnumMock5.enum_array1_names(:entry1, :entry2))
    assert_equal([['エントリ1', 1], ['エントリ2', 2], ['エントリ3', 3]], EnumMock5.enum_array1_options)
    assert_equal([['エントリ2', 2], ['エントリ3', 3]], EnumMock5.enum_array1_options(:entry2, :entry3))
    assert_equal([['エントリ1', 1], ['エントリ2', 2]], EnumMock5.enum_array1_options(1,2))

    assert_equal(nil, EnumMock5.enum_array1_id_by_key(nil))
    assert_equal(1, EnumMock5.enum_array1_id_by_key(:entry1))
    assert_equal(2, EnumMock5.enum_array1_id_by_key(:entry2))
    assert_equal(3, EnumMock5.enum_array1_id_by_key(:entry3))
    assert_equal(nil, EnumMock5.enum_array1_name_by_key(nil))
    assert_equal("エントリ1", EnumMock5.enum_array1_name_by_key(:entry1))
    assert_equal("エントリ2", EnumMock5.enum_array1_name_by_key(:entry2))
    assert_equal("エントリ3", EnumMock5.enum_array1_name_by_key(:entry3))

    assert_equal(nil, EnumMock5.enum_array1_key_by_id(nil))
    assert_equal(:entry1, EnumMock5.enum_array1_key_by_id(1))
    assert_equal(:entry2, EnumMock5.enum_array1_key_by_id(2))
    assert_equal(:entry3, EnumMock5.enum_array1_key_by_id(3))
    assert_equal(nil, EnumMock5.enum_array1_name_by_id(nil))
    assert_equal("エントリ1", EnumMock5.enum_array1_name_by_id(1))
    assert_equal("エントリ2", EnumMock5.enum_array1_name_by_id(2))
    assert_equal("エントリ3", EnumMock5.enum_array1_name_by_id(3))
    
    mock5 = EnumMock5.new
    assert_equal([
        {:id => 1, :key => :entry1, :name => "エントリ1", :select => false},
        {:id => 2, :key => :entry2, :name => "エントリ2", :select => false},
        {:id => 3, :key => :entry3, :name => "エントリ3", :select => false}
      ], mock5.enum_array1_hash_array)
    assert_equal([false, false, false], mock5.enum_array1_selection)
    assert_equal(nil, mock5.enum_array1)
    assert_equal([], mock5.enum_array1_entries)
    assert_equal([], mock5.enum_array1_keys)
    assert_equal([], mock5.enum_array1_names)
    
    mock5.enum_array1 = ''
    assert_equal([
        {:id => 1, :key => :entry1, :name => "エントリ1", :select => false},
        {:id => 2, :key => :entry2, :name => "エントリ2", :select => false},
        {:id => 3, :key => :entry3, :name => "エントリ3", :select => false}
      ], mock5.enum_array1_hash_array)
    assert_equal([false, false, false], mock5.enum_array1_selection)
    assert_equal("", mock5.enum_array1)
    assert_equal([], mock5.enum_array1_entries)
    assert_equal([], mock5.enum_array1_keys)
    assert_equal([], mock5.enum_array1_names)

    mock5.enum_array1 = "3"
    assert_equal([
        {:id => 1, :key => :entry1, :name => "エントリ1", :select => false},
        {:id => 2, :key => :entry2, :name => "エントリ2", :select => false},
        {:id => 3, :key => :entry3, :name => "エントリ3", :select => true}
      ], mock5.enum_array1_hash_array)
    assert_equal([false, false, true], mock5.enum_array1_selection)
    assert_equal("3", mock5.enum_array1)
    assert_equal([3], mock5.enum_array1_entries.map(&:id))
    assert_equal([:entry3], mock5.enum_array1_keys)
    assert_equal(['エントリ3'], mock5.enum_array1_names)
    
    mock5.enum_array1 = '2,3'
    assert_equal([
        {:id => 1, :key => :entry1, :name => "エントリ1", :select => false},
        {:id => 2, :key => :entry2, :name => "エントリ2", :select => true},
        {:id => 3, :key => :entry3, :name => "エントリ3", :select => true}
      ], mock5.enum_array1_hash_array)
    assert_equal([false, true, true], mock5.enum_array1_selection)
    assert_equal('2,3', mock5.enum_array1)
    assert_equal([2, 3], mock5.enum_array1_entries.map(&:id))
    assert_equal([:entry2, :entry3], mock5.enum_array1_keys)
    assert_equal(['エントリ2', 'エントリ3'], mock5.enum_array1_names)

    mock5.enum_array1 = [1,2,3]
    assert_equal([
        {:id => 1, :key => :entry1, :name => "エントリ1", :select => true},
        {:id => 2, :key => :entry2, :name => "エントリ2", :select => true},
        {:id => 3, :key => :entry3, :name => "エントリ3", :select => true}
      ], mock5.enum_array1_hash_array)
    assert_equal([true, true, true], mock5.enum_array1_selection)
    assert_equal([1, 2, 3], mock5.enum_array1_ids)
    assert_equal([1, 2, 3], mock5.enum_array1_entries.map(&:id))
    assert_equal([:entry1, :entry2, :entry3], mock5.enum_array1_keys)
    assert_equal(['エントリ1', 'エントリ2', 'エントリ3'], mock5.enum_array1_names)
    
    mock5.enum_array1_ids = [1,3]; assert_equal('1,3', mock5.enum_array1)
    mock5.enum_array1_ids = [1,2]; assert_equal('1,2', mock5.enum_array1)
    mock5.enum_array1_ids = [2  ]; assert_equal('2'  , mock5.enum_array1)

    mock5.enum_array1_keys = [:entry1,:entry3]; assert_equal('1,3', mock5.enum_array1)
    mock5.enum_array1_keys = [:entry1,:entry2]; assert_equal('1,2', mock5.enum_array1)
    mock5.enum_array1_keys = [:entry2        ]; assert_equal('2'  , mock5.enum_array1)

    mock5.enum_array1_selection = [true, false, true ]; assert_equal('1,3', mock5.enum_array1)
    mock5.enum_array1_selection = [true, true, false ]; assert_equal('1,2', mock5.enum_array1)
    mock5.enum_array1_selection = [false, true, false]; assert_equal('2'  , mock5.enum_array1)

    mock5.enum_array1_ids = "1,3"; assert_equal('1,3', mock5.enum_array1)
    mock5.enum_array1_ids = "1,2"; assert_equal('1,2', mock5.enum_array1)
    mock5.enum_array1_ids = "2"  ; assert_equal('2'  , mock5.enum_array1)
  end
  
end
