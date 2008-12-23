# -*- coding: utf-8 -*-
if defined?(I18n)
  require File.join(File.dirname(__FILE__), 'test_helper')

  class SelectableAttrI18nTest < Test::Unit::TestCase

    def setup
      I18n.backend = I18n::Backend::Simple.new
      I18n.backend.store_translations 'en', :selectable_attrs => {:enum1 => {
          :entry1 => 'entry one',
          :entry2 => 'entry two',
          :entry3 => 'entry three'
        } }
      I18n.backend.store_translations 'ja', :selectable_attrs => {:enum1 => {
          :entry1 => 'エントリ壱',
          :entry2 => 'エントリ弐',
          :entry3 => 'エントリ参'
        } }
    end

    Enum1 = SelectableAttr::Enum.new do
      i18n_scope(:selectable_attrs, :enum1)
      entry 1, :entry1, "エントリ1"
      entry 2, :entry2, "エントリ2"
      entry 3, :entry3, "エントリ3"
    end

    def test_enum1_i18n
      I18n.locale = nil
      # assert_equal nil, I18n.locale
      # assert_equal "エントリ1", Enum1.name_by_key(:entry1)
      # assert_equal "エントリ2", Enum1.name_by_key(:entry2)
      # assert_equal "エントリ3", Enum1.name_by_key(:entry3)
      # assert_equal ["エントリ1", "エントリ2", "エントリ3"], Enum1.names
      assert_equal :en, I18n.locale
      assert_equal "entry one", Enum1.name_by_key(:entry1)
      assert_equal "entry two", Enum1.name_by_key(:entry2)
      assert_equal "entry three", Enum1.name_by_key(:entry3)
      assert_equal ["entry one", "entry two", "entry three"], Enum1.names

      I18n.locale = 'ja'
      assert_equal "エントリ壱", Enum1.name_by_key(:entry1)
      assert_equal "エントリ弐", Enum1.name_by_key(:entry2)
      assert_equal "エントリ参", Enum1.name_by_key(:entry3)
      assert_equal ["エントリ壱", "エントリ弐", "エントリ参"], Enum1.names

      I18n.locale = 'en'
      assert_equal "entry one", Enum1.name_by_key(:entry1)
      assert_equal "entry two", Enum1.name_by_key(:entry2)
      assert_equal "entry three", Enum1.name_by_key(:entry3)
      assert_equal ["entry one", "entry two", "entry three"], Enum1.names
    end

    class EnumBase
      include ::SelectableAttr::Base
    end

    class SelectableAttrMock1 < EnumBase
      selectable_attr :attr1, :default => 2 do
        i18n_scope(:selectable_attrs, :enum1)
        entry 1, :entry1, "エントリ1"
        entry 2, :entry2, "エントリ2"
        entry 3, :entry3, "エントリ3"
      end
    end

    def test_attr1_i18n
      I18n.default_locale = 'ja'
      I18n.locale = nil
      # assert_equal nil, I18n.locale
      # assert_equal "エントリ1", SelectableAttrMock1.attr1_name_by_key(:entry1)
      # assert_equal "エントリ2", SelectableAttrMock1.attr1_name_by_key(:entry2)
      # assert_equal "エントリ3", SelectableAttrMock1.attr1_name_by_key(:entry3)
      assert_equal 'ja', I18n.locale
      assert_equal "エントリ壱", SelectableAttrMock1.attr1_name_by_key(:entry1)
      assert_equal "エントリ弐", SelectableAttrMock1.attr1_name_by_key(:entry2)
      assert_equal "エントリ参", SelectableAttrMock1.attr1_name_by_key(:entry3)
      assert_equal [["エントリ壱",1], ["エントリ弐",2], ["エントリ参",3]], SelectableAttrMock1.attr1_options
      
      I18n.locale = 'ja'
      assert_equal "エントリ壱", SelectableAttrMock1.attr1_name_by_key(:entry1)
      assert_equal "エントリ弐", SelectableAttrMock1.attr1_name_by_key(:entry2)
      assert_equal "エントリ参", SelectableAttrMock1.attr1_name_by_key(:entry3)
      assert_equal [["エントリ壱",1], ["エントリ弐",2], ["エントリ参",3]], SelectableAttrMock1.attr1_options

      I18n.locale = 'en'
      assert_equal "entry one", SelectableAttrMock1.attr1_name_by_key(:entry1)
      assert_equal "entry two", SelectableAttrMock1.attr1_name_by_key(:entry2)
      assert_equal "entry three", SelectableAttrMock1.attr1_name_by_key(:entry3)
      assert_equal [["entry one",1], ["entry two",2], ["entry three",3]], SelectableAttrMock1.attr1_options
    end

    class SelectableAttrMock2 < EnumBase
      selectable_attr :enum1, :default => 2 do
        entry 1, :entry1, "エントリ1"
        entry 2, :entry2, "エントリ2"
        entry 3, :entry3, "エントリ3"
      end
    end

    def test_enum1_i18n
      I18n.default_locale = 'ja'
      I18n.locale = nil
      # assert_equal nil, I18n.locale
      # assert_equal "エントリ1", SelectableAttrMock2.enum1_name_by_key(:entry1)
      # assert_equal "エントリ2", SelectableAttrMock2.enum1_name_by_key(:entry2)
      # assert_equal "エントリ3", SelectableAttrMock2.enum1_name_by_key(:entry3)
      assert_equal 'ja', I18n.locale
      assert_equal "エントリ壱", SelectableAttrMock2.enum1_name_by_key(:entry1)
      assert_equal "エントリ弐", SelectableAttrMock2.enum1_name_by_key(:entry2)
      assert_equal "エントリ参", SelectableAttrMock2.enum1_name_by_key(:entry3)
      assert_equal [["エントリ壱",1], ["エントリ弐",2], ["エントリ参",3]], SelectableAttrMock2.enum1_options

      I18n.locale = 'ja'
      assert_equal "エントリ壱", SelectableAttrMock2.enum1_name_by_key(:entry1)
      assert_equal "エントリ弐", SelectableAttrMock2.enum1_name_by_key(:entry2)
      assert_equal "エントリ参", SelectableAttrMock2.enum1_name_by_key(:entry3)
      assert_equal [["エントリ壱",1], ["エントリ弐",2], ["エントリ参",3]], SelectableAttrMock2.enum1_options

      I18n.locale = 'en'
      assert_equal "entry one", SelectableAttrMock2.enum1_name_by_key(:entry1)
      assert_equal "entry two", SelectableAttrMock2.enum1_name_by_key(:entry2)
      assert_equal "entry three", SelectableAttrMock2.enum1_name_by_key(:entry3)
      assert_equal [["entry one",1], ["entry two",2], ["entry three",3]], SelectableAttrMock2.enum1_options
    end

  end
end
