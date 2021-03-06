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

module Mahuta
  
  class Schema
    
    def initialize(mapping = {}, &block)
      @mapping = mapping
      instance_exec &block if block
    end
    
    def new(file = nil, &block)
      if block
        Mahuta.with_location(file) { Mahuta.build self, &block }
      elsif file
        Mahuta.with_location(file) { Mahuta.build(self) { eval File.read(file), binding, file.to_s } }
      end
    end
    
    def [](key)
      case key
      when Symbol, String
        [*@mapping[key.to_sym]]
      end
    end
    
    def type(name, *mod, &block)
      type = if mod.empty?
        Module.new.tap do |type|
          type.module_exec &block if block
        end
      else
        mod
      end
      (@mapping[name.to_sym] ||= []).push(*type)
      type
    end
    
  end
  
end
