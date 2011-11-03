# -*- coding: utf-8 -*-
require File.join(File.dirname(__FILE__), 'spec_helper')

describe SelectableAttr::Enum do

  Enum1 = SelectableAttr::Enum.new do
    entry 1, :book, '書籍'
    entry 2, :dvd, 'DVD'
    entry 3, :cd, 'CD'
    entry 4, :vhs, 'VHS'
  end

  it "test_define" do
    Enum1[1].id.should == 1
    Enum1[2].id.should == 2
    Enum1[3].id.should == 3
    Enum1[4].id.should == 4
    Enum1[1].key.should == :book
    Enum1[2].key.should == :dvd
    Enum1[3].key.should == :cd
    Enum1[4].key.should == :vhs
    Enum1[1].name.should == '書籍'
    Enum1[2].name.should == 'DVD'
    Enum1[3].name.should == 'CD'
    Enum1[4].name.should == 'VHS'

    Enum1[:book].id.should == 1
    Enum1[:dvd ].id.should == 2
    Enum1[:cd  ].id.should == 3
    Enum1[:vhs ].id.should == 4
    Enum1[:book].key.should == :book
    Enum1[:dvd ].key.should == :dvd
    Enum1[:cd  ].key.should == :cd
    Enum1[:vhs ].key.should == :vhs
    Enum1[:book].name.should == '書籍'
    Enum1[:dvd].name.should  == 'DVD'
    Enum1[:cd].name.should   == 'CD'
    Enum1[:vhs].name.should  == 'VHS'

    Enum1.values.should == [['書籍', 1], ['DVD', 2], ['CD', 3], ['VHS', 4]]
    Enum1.values(:name, :id).should == [['書籍', 1], ['DVD', 2], ['CD', 3], ['VHS', 4]]
    Enum1.values(:name, :key).should == [['書籍', :book], ['DVD', :dvd], ['CD', :cd], ['VHS', :vhs]]
  end

  InetAccess = SelectableAttr::Enum.new do
    entry 1, :email, 'Eメール', :protocol => 'mailto:'
    entry 2, :website, 'ウェブサイト', :protocol => 'http://'
    entry 3, :ftp, 'FTP', :protocol => 'ftp://'
  end

  it "test_define_with_options" do
    InetAccess[1].id.should == 1
    InetAccess[2].id.should == 2
    InetAccess[3].id.should == 3
    InetAccess[1].key.should == :email
    InetAccess[2].key.should == :website
    InetAccess[3].key.should == :ftp


    InetAccess[1].name.should == 'Eメール'
    InetAccess[2].name.should == 'ウェブサイト'
    InetAccess[3].name.should == 'FTP'
    InetAccess[1][:protocol].should == 'mailto:'
    InetAccess[2][:protocol].should == 'http://'
    InetAccess[3][:protocol].should == 'ftp://'

    InetAccess[9].id.should be_nil
    InetAccess[9].key.should be_nil
    InetAccess[9].name.should be_nil
    InetAccess[9][:protocol].should be_nil
    InetAccess[9][:xxxx].should be_nil
  end

  it "test_get_by_option" do
    InetAccess[:protocol => 'mailto:'].should == InetAccess[1]
    InetAccess[:protocol => 'http://'].should == InetAccess[2]
    InetAccess[:protocol => 'ftp://'].should == InetAccess[3]
  end

  it "test_null?" do
    InetAccess[1].null?.should == false
    InetAccess[2].null?.should == false
    InetAccess[3].null?.should == false
    InetAccess[9].null?.should == true
    InetAccess[:protocol => 'mailto:'].null?.should == false
    InetAccess[:protocol => 'http://'].null?.should == false
    InetAccess[:protocol => 'ftp://'].null?.should == false
    InetAccess[:protocol => 'svn://'].null?.should == true
  end

  it "test_null_object?" do
    InetAccess[1].null_object?.should == false
    InetAccess[2].null_object?.should == false
    InetAccess[3].null_object?.should == false
    InetAccess[9].null_object?.should == true
    InetAccess[:protocol => 'mailto:'].null_object?.should == false
    InetAccess[:protocol => 'http://'].null_object?.should == false
    InetAccess[:protocol => 'ftp://'].null_object?.should == false
    InetAccess[:protocol => 'svn://'].null_object?.should == true
  end

  it "test_to_hash_array" do
    Enum1.to_hash_array.should == [
        {:id => 1, :key => :book, :name => '書籍'},
        {:id => 2, :key => :dvd, :name => 'DVD'},
        {:id => 3, :key => :cd, :name => 'CD'},
        {:id => 4, :key => :vhs, :name => 'VHS'}
      ]

    InetAccess.to_hash_array.should == [
        {:id => 1, :key => :email, :name => 'Eメール', :protocol => 'mailto:'},
        {:id => 2, :key => :website, :name => 'ウェブサイト', :protocol => 'http://'},
        {:id => 3, :key => :ftp, :name => 'FTP', :protocol => 'ftp://'}
      ]
  end

  describe "find" do
    it "with options" do
      InetAccess.find(:protocol => 'http://').should == InetAccess[2]
      InetAccess.find(:protocol => 'svn+ssh://').should == SelectableAttr::Enum::Entry::NULL
    end

    it "with block" do
      InetAccess.find{|entry| entry.key.to_s =~ /tp/}.should == InetAccess[3]
      InetAccess.find{|entry| entry.key.to_s =~ /XXXXXX/}.should == SelectableAttr::Enum::Entry::NULL
    end
  end

  describe :inspect do
    it "NULL" do
      SelectableAttr::Enum::Entry::NULL.inspect.should =~ /\#<SelectableAttr::Enum::Entry:[\.0-9a-f]+\ @id=nil,\ @key=nil,\ @name=nil,\ @options=nil>/
    end

    it "valid" do
      InetAccess[1].inspect.should =~ /\#<SelectableAttr::Enum::Entry:[\.0-9a-f]+\ @id=1,\ @key=:email,\ @name="Eメール",\ @options=\{:protocol=>"mailto:"\}>/
    end
  end

end
