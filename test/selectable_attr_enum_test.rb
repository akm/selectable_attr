# -*- coding: utf-8 -*-
require File.join(File.dirname(__FILE__), 'test_helper')

class SelectableAttrEnumTest < Test::Unit::TestCase

  Enum1 = SelectableAttr::Enum.new do
    entry 1, :book, '書籍'
    entry 2, :dvd, 'DVD'
    entry 3, :cd, 'CD'
    entry 4, :vhs, 'VHS'
  end

  def test_define
    assert_equal 1, Enum1[1].id
    assert_equal 2, Enum1[2].id
    assert_equal 3, Enum1[3].id
    assert_equal 4, Enum1[4].id
    assert_equal :book, Enum1[1].key
    assert_equal :dvd, Enum1[2].key
    assert_equal :cd, Enum1[3].key
    assert_equal :vhs, Enum1[4].key
    assert_equal '書籍', Enum1[1].name
    assert_equal 'DVD', Enum1[2].name
    assert_equal 'CD', Enum1[3].name
    assert_equal 'VHS', Enum1[4].name

    assert_equal 1, Enum1[:book].id
    assert_equal 2, Enum1[:dvd].id
    assert_equal 3, Enum1[:cd].id
    assert_equal 4, Enum1[:vhs].id
    assert_equal :book, Enum1[:book].key
    assert_equal :dvd, Enum1[:dvd].key
    assert_equal :cd, Enum1[:cd].key
    assert_equal :vhs, Enum1[:vhs].key
    assert_equal '書籍', Enum1[:book].name
    assert_equal 'DVD', Enum1[:dvd].name
    assert_equal 'CD', Enum1[:cd].name
    assert_equal 'VHS', Enum1[:vhs].name
    
    assert_equal [['書籍', 1], ['DVD', 2], ['CD', 3], ['VHS', 4]], Enum1.values
    assert_equal [['書籍', 1], ['DVD', 2], ['CD', 3], ['VHS', 4]], Enum1.values(:name, :id)
    assert_equal [['書籍', :book], ['DVD', :dvd], ['CD', :cd], ['VHS', :vhs]], Enum1.values(:name, :key)
  end

  InetAccess = SelectableAttr::Enum.new do
    entry 1, :email, 'Eメール', :protocol => 'mailto:'
    entry 2, :website, 'ウェブサイト', :protocol => 'http://'
    entry 3, :ftp, 'FTP', :protocol => 'ftp://'
  end

  def test_define_with_options
    assert_equal 1, InetAccess[1].id
    assert_equal 2, InetAccess[2].id
    assert_equal 3, InetAccess[3].id
    assert_equal :email, InetAccess[1].key
    assert_equal :website, InetAccess[2].key
    assert_equal :ftp, InetAccess[3].key
    assert_equal 'Eメール', InetAccess[1].name
    assert_equal 'ウェブサイト', InetAccess[2].name
    assert_equal 'FTP', InetAccess[3].name
    assert_equal 'mailto:', InetAccess[1][:protocol]
    assert_equal 'http://', InetAccess[2][:protocol]
    assert_equal 'ftp://', InetAccess[3][:protocol]

    assert_equal nil, InetAccess[9].id
    assert_equal nil, InetAccess[9].key
    assert_equal nil, InetAccess[9].name
    assert_equal nil, InetAccess[9][:protocol]
    assert_equal nil, InetAccess[9][:xxxx]
  end

  def test_get_by_option
    assert_equal InetAccess[1], InetAccess[:protocol => 'mailto:']
    assert_equal InetAccess[2], InetAccess[:protocol => 'http://']
    assert_equal InetAccess[3], InetAccess[:protocol => 'ftp://']
  end
  
  def test_null?
    assert_equal false, InetAccess[1].null?
    assert_equal false, InetAccess[2].null?
    assert_equal false, InetAccess[3].null?
    assert_equal true, InetAccess[9].null?

    assert_equal false, InetAccess[:protocol => 'mailto:'].null?
    assert_equal false, InetAccess[:protocol => 'http://'].null?
    assert_equal false, InetAccess[:protocol => 'ftp://'].null?
    assert_equal true, InetAccess[:protocol => 'svn://'].null?
  end
  
  def test_null_object?
    assert_equal false, InetAccess[1].null_object?
    assert_equal false, InetAccess[2].null_object?
    assert_equal false, InetAccess[3].null_object?
    assert_equal true, InetAccess[9].null_object?

    assert_equal false, InetAccess[:protocol => 'mailto:'].null_object?
    assert_equal false, InetAccess[:protocol => 'http://'].null_object?
    assert_equal false, InetAccess[:protocol => 'ftp://'].null_object?
    assert_equal true, InetAccess[:protocol => 'svn://'].null_object?
  end
  
  def test_to_hash_array
    assert_equal [
        {:id => 1, :key => :book, :name => '書籍'},
        {:id => 2, :key => :dvd, :name => 'DVD'},
        {:id => 3, :key => :cd, :name => 'CD'},
        {:id => 4, :key => :vhs, :name => 'VHS'}
      ], Enum1.to_hash_array
    
    assert_equal [
        {:id => 1, :key => :email, :name => 'Eメール', :protocol => 'mailto:'},
        {:id => 2, :key => :website, :name => 'ウェブサイト', :protocol => 'http://'},
        {:id => 3, :key => :ftp, :name => 'FTP', :protocol => 'ftp://'}
      ], InetAccess.to_hash_array
  end

end
