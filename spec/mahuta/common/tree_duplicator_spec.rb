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

RSpec.describe Mahuta::Common::TreeDuplicator do
  
  subject do
    Class.new.tap do |cl|
      cl.instance_exec do
        include Mahuta::Visitor
        include Mahuta::Common::TreeProducer
        include Mahuta::Common::TreeDuplicator
      end
    end
  end
  
  
  
end
