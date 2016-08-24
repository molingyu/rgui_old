#encoding: utf-8
#author: shitake
#data: 16-8-24

class XMLLikeParser
  class Node

    attr_accessor :name
    attr_accessor :attr
    attr_accessor :child
    attr_accessor :value
    def initialize(name, attr, child = {})
      @name = name
      @attr = attr
      @value = ''
      @child = child
    end

    def add_attr(name, val)
      @attr.include?(name) ? (raise "The attribute #{name} already exists!") : @attr[name] = val
    end

    def add_child(val)
      @child.push(val)
    end
  end

  attr_reader :root

  def initialize(code, conf = {})
    @node_style, @attr_style, @end_node = conf
    @root = Node.new('root', {}, code)
    parse(@root)
  end

  def parse(node)
    return if @end_node.include?(node.name)
    node.child = parse_node(node.child, [])
    node.child.each do |n|
      parse(n)
    end
  end

  def parse_node(code, child)
    return child unless code
    code.strip!
    str = ''
    index = 0
    new_node = nil
    if code == ''
      return child
    elsif code[0] != '<'
      new_node = Node.new('text', {})
      new_node.value = code.include?('<') ? code[0, index = code.index('<')] : (index = code.size;code)
      child.push(new_node)
    else
      str = (@node_style.class == Array) ? @node_style.each{ |node| break code[node] if code[node] } : code[@node_style]
      if str
        index = code.index(str) + str.size
        new_node = Node.new($1, parse_attr($2, {}), $3)
        child.push(new_node)
      else
        index = code.size
        new_node = Node.new('text', {})
        new_node.value = code
        child.push(new_node)
      end
    end
    parse_node(code[index, code.size], child) if code.size > index
    child
  end

  def parse_attr(code ,attr)
    return attr unless code
    code.strip!
    str = code[@attr_style]
    return attr unless str
    index = code.index(str) + str.size
    code = code[index, code.size - index]
    attr[$1.to_sym] = $2
    parse_attr(code, attr)
  end
end

module XML
  class <<self
    def xml2node(code)
      xml = [[/^<([a-zA-Z]+[^<^ ]*)([^<]*)\/>/, /^<([a-zA-Z]+[^<^ ]*)([^<]*)>([^<]*)<\/\1>/m], # node style
          /([a-zA-Z]+[^=]*)="([^"]*)"/, # attr style
          ['text']] # end node
      XMLLikeParser.new(code, xml).root
    end
  end
end

module Kernel
  def xml(value)
    XML.xml2node(value)
  end
end
require 'pp'
pp xml('233').child