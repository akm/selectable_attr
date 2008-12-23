# -*- coding: utf-8 -*-
require File.join(File.dirname(__FILE__), 'test_helper')

class IntroductionTest < Test::Unit::TestCase

  def assert_product_discount(klass)
    # productsテーブルのデータから安売り用の価格は
    # product_type_cd毎に決められた割合をpriceにかけて求めます。
    p1 = klass.new(:name => '実践Rails', :product_type_cd => '01', :price => 3000)
    assert_equal 2400, p1.discount_price
    p2 = klass.new(:name => '薔薇の名前', :product_type_cd => '02', :price => 1500)
    assert_equal 300, p2.discount_price
    p3 = klass.new(:name => '未来派野郎', :product_type_cd => '03', :price => 3000)
    assert_equal 1500, p3.discount_price
  end
  
  # 定数をガンガン定義した場合
  # 大文字が多くて読みにくいし、関連するデータ(ここではDISCOUNT)が増える毎に定数も増えていきます。
  class LegacyProduct1 < ActiveRecord::Base
    set_table_name 'products'
    
    PRODUCT_TYPE_BOOK = '01'
    PRODUCT_TYPE_DVD = '02'
    PRODUCT_TYPE_CD = '03'
    PRODUCT_TYPE_OTHER = '09'
    
    PRODUCT_TYPE_OPTIONS = [
      ['書籍', PRODUCT_TYPE_BOOK],
      ['DVD', PRODUCT_TYPE_DVD],
      ['CD', PRODUCT_TYPE_CD],
      ['その他', PRODUCT_TYPE_OTHER]
    ]
    
    DISCOUNT = { 
      PRODUCT_TYPE_BOOK => 0.8,
      PRODUCT_TYPE_DVD => 0.2,
      PRODUCT_TYPE_CD => 0.5,
      PRODUCT_TYPE_OTHER => 1
    }
    
    def discount_price
      (DISCOUNT[product_type_cd] * price).to_i
    end
  end
  
  def test_legacy_product
    assert_product_discount(LegacyProduct1)
    
    # 選択肢を表示するためのデータは以下のように取得できる
    assert_equal([['書籍', '01'], ['DVD', '02'], ['CD', '03'], ['その他', '09']], 
      LegacyProduct1::PRODUCT_TYPE_OPTIONS)
  end
  
  
  
  
  # できるだけ定数定義をまとめた場合
  # 結構すっきりするけど、同じことをいろんなモデルで書くかと思うと気が重い。
  class LegacyProduct2 < ActiveRecord::Base
    set_table_name 'products'
    
    PRODUCT_TYPE_DEFS = [
      {:id => '01', :name => '書籍', :discount => 0.8},
      {:id => '02', :name => 'DVD', :discount => 0.2},
      {:id => '03', :name => 'CD', :discount => 0.5},
      {:id => '09', :name => 'その他', :discount => 1}
    ]
    
    PRODUCT_TYPE_OPTIONS = PRODUCT_TYPE_DEFS.map{|t| [t[:name], t[:id]]}
    DISCOUNT = PRODUCT_TYPE_DEFS.inject({}){|dest, t| 
      dest[t[:id]] = t[:discount]; dest}
      
    def discount_price
      (DISCOUNT[product_type_cd] * price).to_i
    end
  end
  
  def test_legacy_product
    assert_product_discount(LegacyProduct2)
    
    # 選択肢を表示するためのデータは以下のように取得できる
    assert_equal([['書籍', '01'], ['DVD', '02'], ['CD', '03'], ['その他', '09']], 
      LegacyProduct2::PRODUCT_TYPE_OPTIONS)
  end
  
  # selectable_attrを使った場合
  # 定義は一カ所にまとめられて、任意の属性(ここでは:discount)も一緒に書くことができてすっきり〜
  class Product1 < ActiveRecord::Base
    set_table_name 'products'
    
    selectable_attr :product_type_cd do
      entry '01', :book, '書籍', :discount => 0.8
      entry '02', :dvd, 'DVD', :discount => 0.2
      entry '03', :cd, 'CD', :discount => 0.5
      entry '09', :other, 'その他', :discount => 1
    end

    def discount_price
      (product_type_entry[:discount] * price).to_i
    end
  end
  
  def test_product1
    assert_product_discount(Product1)
    # 選択肢を表示するためのデータは以下のように取得できる
    assert_equal([['書籍', '01'], ['DVD', '02'], ['CD', '03'], ['その他', '09']], 
      Product1.product_type_options)
  end
  
  
  # selectable_attrが定義するインスタンスメソッドの詳細
  def test_product_type_instance_methods
    p1 = Product1.new
    assert_equal nil, p1.product_type_cd
    assert_equal nil, p1.product_type_key
    assert_equal nil, p1.product_type_name
    # idを変更すると得られるキーも名称も変わります
    p1.product_type_cd = '02'
    assert_equal '02', p1.product_type_cd
    assert_equal :dvd, p1.product_type_key
    assert_equal 'DVD', p1.product_type_name
    # キーを変更すると得られるidも名称も変わります
    p1.product_type_key = :book
    assert_equal '01', p1.product_type_cd
    assert_equal :book, p1.product_type_key
    assert_equal '書籍', p1.product_type_name
    # id、キー、名称以外の任意の属性は、entryの[]メソッドで取得します。
    p1.product_type_key = :cd
    assert_equal 0.5, p1.product_type_entry[:discount]
  end
  
  # selectable_attrが定義するクラスメソッドの詳細
  def test_product_type_class_methods
    # キーからid、名称を取得できます
    assert_equal '01', Product1.product_type_id_by_key(:book)
    assert_equal '02', Product1.product_type_id_by_key(:dvd)
    assert_equal '03', Product1.product_type_id_by_key(:cd)
    assert_equal '09', Product1.product_type_id_by_key(:other)
    assert_equal '書籍', Product1.product_type_name_by_key(:book)
    assert_equal 'DVD', Product1.product_type_name_by_key(:dvd)
    assert_equal 'CD', Product1.product_type_name_by_key(:cd)
    assert_equal 'その他', Product1.product_type_name_by_key(:other)
    # 存在しないキーの場合はnilを返します
    assert_equal nil, Product1.product_type_id_by_key(nil)
    assert_equal nil, Product1.product_type_name_by_key(nil)
    assert_equal nil, Product1.product_type_id_by_key(:unexist)
    assert_equal nil, Product1.product_type_name_by_key(:unexist)

    # idからキー、名称を取得できます
    assert_equal :book, Product1.product_type_key_by_id('01')
    assert_equal :dvd, Product1.product_type_key_by_id('02')
    assert_equal :cd, Product1.product_type_key_by_id('03')
    assert_equal :other, Product1.product_type_key_by_id('09')
    assert_equal '書籍', Product1.product_type_name_by_id('01')
    assert_equal 'DVD', Product1.product_type_name_by_id('02')
    assert_equal 'CD', Product1.product_type_name_by_id('03')
    assert_equal 'その他', Product1.product_type_name_by_id('09')
    # 存在しないidの場合はnilを返します
    assert_equal nil, Product1.product_type_key_by_id(nil)
    assert_equal nil, Product1.product_type_name_by_id(nil)
    assert_equal nil, Product1.product_type_key_by_id('99')
    assert_equal nil, Product1.product_type_name_by_id('99')
    
    # id、キー、名称の配列を取得できます
    assert_equal ['01', '02', '03', '09'], Product1.product_type_ids
    assert_equal [:book, :dvd, :cd, :other], Product1.product_type_keys
    assert_equal ['書籍', 'DVD', 'CD', 'その他'], Product1.product_type_names
    # 一部のものだけ取得することも可能です。
    assert_equal ['03', '02'], Product1.product_type_ids(:cd, :dvd)
    assert_equal [:dvd, :cd], Product1.product_type_keys('02', '03')
    assert_equal ['DVD', 'CD'], Product1.product_type_names('02', '03')
    assert_equal ['CD', 'DVD'], Product1.product_type_names(:cd, :dvd)
    
    # select_tagなどのoption_tagsを作るための配列なんか一発っす
    assert_equal([['書籍', '01'], ['DVD', '02'], ['CD', '03'], ['その他', '09']], 
      Product1.product_type_options)
  end

  
  
  
  # Q: product_type_cd の'_cd'はどこにいっちゃったの？
  # A: デフォルトでは、/(_cd$|_code$|_cds$|_codes$)/ を削除したものをbase_nameとして
  #    扱い、それに_keyなどを付加してメソッド名を定義します。もしこのルールを変更したい場合、
  #    selectable_attrを使う前に selectable_attr_name_pattern で新たなルールを指定してください。
  class Product2 < ActiveRecord::Base
    set_table_name 'products'
    self.selectable_attr_name_pattern = /^product_|_cd$/
    
    selectable_attr :product_type_cd do
      entry '01', :book, '書籍', :discount => 0.8
      entry '02', :dvd, 'DVD', :discount => 0.2
      entry '03', :cd, 'CD', :discount => 0.5
      entry '09', :other, 'その他', :discount => 1
    end

    def discount_price
      (type_entry[:discount] * price).to_i
    end
  end
  
  def test_product2
    assert_product_discount(Product2)
    # 選択肢を表示するためのデータは以下のように取得できる
    assert_equal([['書籍', '01'], ['DVD', '02'], ['CD', '03'], ['その他', '09']], 
      Product2.type_options)

    p2 = Product2.new
    assert_equal nil, p2.product_type_cd
    assert_equal nil, p2.type_key
    assert_equal nil, p2.type_name
    # idを変更すると得られるキーも名称も変わります
    p2.product_type_cd = '02'
    assert_equal '02', p2.product_type_cd
    assert_equal :dvd, p2.type_key
    assert_equal 'DVD', p2.type_name
    # キーを変更すると得られるidも名称も変わります
    p2.type_key = :book
    assert_equal '01', p2.product_type_cd
    assert_equal :book, p2.type_key
    assert_equal '書籍', p2.type_name
    # id、キー、名称以外の任意の属性は、entryの[]メソッドで取得します。
    p2.type_key = :cd
    assert_equal 0.5, p2.type_entry[:discount]
    
    assert_equal '01', Product2.type_id_by_key(:book)
    assert_equal '02', Product2.type_id_by_key(:dvd)
    assert_equal 'CD', Product2.type_name_by_key(:cd)
    assert_equal 'その他', Product2.type_name_by_key(:other)
    assert_equal :other, Product2.type_key_by_id('09')
    assert_equal '書籍', Product2.type_name_by_id('01')
    assert_equal [:book, :dvd, :cd, :other], Product2.type_keys
    assert_equal ['書籍', 'DVD', 'CD', 'その他'], Product2.type_names
    assert_equal [:dvd, :cd], Product2.type_keys('02', '03')
    assert_equal ['CD', 'DVD'], Product2.type_names(:cd, :dvd)
  end
  
  
  
  
  # Q: selectable_attrの呼び出し毎にbase_bname(って言うの？)を指定したいんだけど。
  # A: base_nameオプションを指定してください。
  class Product3 < ActiveRecord::Base
    set_table_name 'products'
    
    selectable_attr :product_type_cd, :base_name => 'type' do
      entry '01', :book, '書籍', :discount => 0.8
      entry '02', :dvd, 'DVD', :discount => 0.2
      entry '03', :cd, 'CD', :discount => 0.5
      entry '09', :other, 'その他', :discount => 1
    end

    def discount_price
      (type_entry[:discount] * price).to_i
    end
  end
  
  def test_product3
    assert_product_discount(Product3)
    # 選択肢を表示するためのデータは以下のように取得できる
    assert_equal([['書籍', '01'], ['DVD', '02'], ['CD', '03'], ['その他', '09']], 
      Product3.type_options)

    p3 = Product3.new
    assert_equal nil, p3.product_type_cd
    assert_equal nil, p3.type_key
    assert_equal nil, p3.type_name
    # idを変更すると得られるキーも名称も変わります
    p3.product_type_cd = '02'
    assert_equal '02', p3.product_type_cd
    assert_equal :dvd, p3.type_key
    assert_equal 'DVD', p3.type_name
    # キーを変更すると得られるidも名称も変わります
    p3.type_key = :book
    assert_equal '01', p3.product_type_cd
    assert_equal :book, p3.type_key
    assert_equal '書籍', p3.type_name
    # id、キー、名称以外の任意の属性は、entryの[]メソッドで取得します。
    p3.type_key = :cd
    assert_equal 0.5, p3.type_entry[:discount]
    
    assert_equal '01', Product3.type_id_by_key(:book)
    assert_equal '02', Product3.type_id_by_key(:dvd)
    assert_equal 'CD', Product3.type_name_by_key(:cd)
    assert_equal 'その他', Product3.type_name_by_key(:other)
    assert_equal :other, Product3.type_key_by_id('09')
    assert_equal '書籍', Product3.type_name_by_id('01')
    assert_equal [:book, :dvd, :cd, :other], Product3.type_keys
    assert_equal ['書籍', 'DVD', 'CD', 'その他'], Product3.type_names
    assert_equal [:dvd, :cd], Product3.type_keys('02', '03')
    assert_equal ['CD', 'DVD'], Product3.type_names(:cd, :dvd)
  end
  
end

