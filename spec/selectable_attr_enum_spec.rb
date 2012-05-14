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


  describe "SelectableAttr::Enum#name" do
    context "unspecified" do
      subject { SelectableAttr::Enum.new }
      its(:name){ should == nil}
    end

    context "unspecified" do
      subject { r = SelectableAttr::Enum.new; r.name = "foo"; r }
      its(:name){ should == "foo"}
    end

    context "unspecified" do
      subject do
        SelectableAttr::Enum.new do
          name "bar"
        end
      end
      its(:name){ should == "bar"}
    end
  end

  describe "SelectableAttr::Enum::Entry#==" do
    context "same enum entry" do
      subject{ Enum1.entry_by_id(1) } # entry 1, :book, '書籍'
      it{ should == subject}
      it{ should === subject}
      it{ should eql(subject)}
      it{ should equal(subject)}
    end

    context "an enum entry which has same attributes" do
      subject do
        enum = SelectableAttr::Enum.new{ entry(1, :book, '書籍') }
        enum.entry_by_id(1)
      end
      before{ @other = Enum1.entry_by_id(1) }
      it{ should == @other}
      it{ should === @other}
      it{ should_not eql(@other)}
      it{ should_not equal(@other)}
    end

    context "an enum entry which has same id and key" do
      subject do
        enum = SelectableAttr::Enum.new{ entry(1, :book, '料理') }
        enum.entry_by_id(1)
      end
      before{ @other = Enum1.entry_by_id(1) }
      it{ should == @other}
      it{ should === @other}
      it{ should_not eql(@other)}
      it{ should_not equal(@other)}
    end

    context "an enum entry which has same id" do
      subject do
        enum = SelectableAttr::Enum.new{ entry(1, :cook, '料理') }
        enum.entry_by_id(1)
      end
      before{ @other = Enum1.entry_by_id(1) }
      it{ should == @other}
      it{ should_not === @other}
      it{ should_not eql(@other)}
      it{ should_not equal(@other)}
    end
  end

  describe "SelectableAttr::Enum#==" do
    context "same enum object" do
      subject{ Enum1 }
      it{ should == Enum1}
      it{ should === Enum1}
      it{ should eql(Enum1)}
      it{ should equal(Enum1)}
    end

    context "an object which has same entries" do
      subject do
        SelectableAttr::Enum.new do
          entry 1, :book, '書籍'
          entry 2, :dvd, 'DVD'
          entry 3, :cd, 'CD'
          entry 4, :vhs, 'VHS'
        end
      end

      it{ should == Enum1}
      it{ should === Enum1}
      it{ should_not eql(Enum1)}
      it{ should_not equal(Enum1)}
    end

    context "an object which has entries with same id" do
      subject do
        SelectableAttr::Enum.new do
          entry 1, :cook, '料理'
          entry 2, :blueray, 'BD'
          entry 3, :mv, 'Move Directory'
          entry 4, :UHF, 'Ultra High Frequency'
        end
      end

      it{ should == Enum1}
      it{ should_not === Enum1}
      it{ should_not eql(Enum1)}
      it{ should_not equal(Enum1)}
    end

    context "an object which has same entries with different order" do
      subject do
        SelectableAttr::Enum.new do
          entry 1, :book, '書籍'
          entry 3, :cd, 'CD'
          entry 4, :vhs, 'VHS'
          entry 2, :dvd, 'DVD'
        end
      end

      it{ should_not == Enum1}
      it{ should_not === Enum1}
      it{ should_not eql(Enum1)}
      it{ should_not equal(Enum1)}
    end
  end
end
