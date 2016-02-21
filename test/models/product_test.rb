require 'test_helper'

class ProductTest < ActiveSupport::TestCase
 
  fixtures :products
  
  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end
  
  test "product price must be positive" do
    product = Product.new(
                          title: "My Book Title",
                          description: "yyy",
                          image_url: "zzz.jpg"
                          )
    #Set the product price to -1, and then make sure it is invalid with the assertion
    product.price = -1
    assert product.invalid?
    assert ["must be greater than or equal to 0.01"], product.errors[:price]
    
    #Set the product price to 0, and then make sure it is invalid with the assertion
    product.price = 0
    assert product.invalid?
    assert ["must be greater than or equal to 0.01"], product.errors[:price]
    
    #Set the product price to 1, and then make sure it is valid
    product.price = 1
    assert product.valid?
  end
  
  def new_product(image_url)
    Product.new(
                title: "My Book Title",
                description: "yyy",
                image_url: image_url,
                price: 1
                )
  end
  
  test "image url" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.JpG http://a.a.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }
    ok.each do |nameparam|
      assert new_product(nameparam).valid?, "#{nameparam} should be valid"
    end
    bad.each do |name|
      assert new_product(name).invalid?, "#{name} should not be valid"
    end
  end
  
  test "product is not valid without a unique title" do
    product = Product.new(
                          title: products(:ruby).title,
                          description: "yyy",
                          price: 1,
                          image_url: "fred.gif"
                          )
    assert product.invalid?
    assert_equal ["has already been taken"], product.errors[:title]
  end
end
