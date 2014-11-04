# -*- coding: utf-8 -*-
lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'configulator'
require 'test/unit'

class ConfigulatorTest < Test::Unit::TestCase
  def test_json_load_without_env
    input = {
      "one" => "something",
      "two" => "<%= one %> one",
      "three" => "<%= two %> two"
    }
    c = Configulator.from_json(JSON.dump(input))
    assert_equal c.one, "something"
    assert_equal c.two, "something one"
    assert_equal c.three, "something one two"
  end

  def test_json_load_with_env
    input = {
      "default" => {
        "one" => "something",
        "two" => "<%= one %> one",
        "three" => "<%= two %> two"        
      },
      "test" => {
        "three" => "<%= one %> as three",
        "newone" => 3
      }
    }
    c = Configulator.from_json(JSON.dump(input), "test")
    assert_equal c.one, "something"
    assert_equal c.two, "something one"
    assert_equal c.three, "something as three"
    assert_equal c.newone, 3

    assert_raise RuntimeError do
      Configulator.from_json(JSON.dump(input), "testfake")
    end
  end

  def test_yaml_load_without_env
    input = {
      "one" => "something",
      "two" => "<%= one %> one",
      "three" => "<%= two %> two"
    }
    c = Configulator.from_yaml(YAML.dump(input))
    assert_equal c.one, "something"
    assert_equal c.two, "something one"
    assert_equal c.three, "something one two"
  end

  def test_yaml_load_with_env
    input = {
      "default" => {
        "one" => "something",
        "two" => "<%= one %> one",
        "three" => "<%= two %> two"        
      },
      "test" => {
        "three" => "<%= one %> as three",
        "newone" => 3
      }
    }
    c = Configulator.from_yaml(YAML.dump(input), "test")
    assert_equal c.one, "something"
    assert_equal c.two, "something one"
    assert_equal c.three, "something as three"
    assert_equal c.newone, 3

    assert_raise RuntimeError do
      Configulator.from_yaml(YAML.dump(input), "testfake")
    end
  end
end
