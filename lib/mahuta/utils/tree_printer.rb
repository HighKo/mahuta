# encoding: UTF-8
# Copyright 2017 Max Trense
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#   http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'pastel'

module Mahuta::Utils
  
  class TreePrinter
    include Mahuta::Visitor
    
    P = Pastel.new
    
    SIMPLE_FORMAT = proc do |node, attrs, depth|
      attributes_string = attrs.collect {|n, v| "#{n}=#{v.inspect}" }.join(' ')
      '  '*depth + (node.leaf? ? '-' : '+') + " [#{node.node_type}] #{attributes_string}"
    end
    
    EXTENDED_COLORIZED_FORMAT = proc do |node, attrs, depth|
      attributes_string = attrs.collect {|n, v| "#{P.white(n)}=#{P.cyan(v.inspect)}" }.join(' ')
      '  '*depth + P.bold(node.leaf? ? '-' : '+') + " [#{__type_color(node)}] #{attributes_string}"
    end
    
    def initialize(options = {}, &filter_block)
      @out = options[:out] || $stdout
      @format = case options[:format]
      when Proc
        options[:format]
      when :simple, 'simple'
        SIMPLE_FORMAT
      when :extended, 'extended', nil
        EXTENDED_COLORIZED_FORMAT
      end
      @filter = filter_block || Proc.new { true }
      @internals = !! options[:internals]
      @type_colors = options.delete(:type_colors) || proc { [:bold, :blue] }
      @key_colors = options.delete(:key_colors) || proc { [:yellow] }
      @value_colors = options.delete(:value_colors) || proc { [:cyan] }
    end
    
    def enter(node, depth)
      attrs = node.attributes.select {|k, v| @internals or not k.to_s.start_with?('__') }
      @out.puts instance_exec(node, attrs, depth, &@format) if @filter.call(node)
    end
    
    private def __type_color(node)
      case @type_colors
      when Hash
        P.decorate(node.node_type.to_s, *@type_colors[node.node_type])
      when Proc
        P.decorate(node.node_type.to_s, *instance_exec(node.node_type, node, &@type_colors))
      end
    end
    
  end
  
end
