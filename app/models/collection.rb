# Copyright © 2013 The Pennsylvania State University
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
class Collection < ActiveFedora::Base
  include Hydra::Collection
  include Sufia::Noid
  include Hydra::ModelMixins::RightsMetadata
  
  has_metadata :name => "rightsMetadata", :type => ParanoidRightsDatastream
  validate :paranoid_permissions
  
  def visibility
    public_perm = permissions.map { |perm| perm[:access] if perm[:name] == "public"}.compact.first
    registered_perm = permissions.map { |perm| perm[:access] if perm[:name] == "registered"}.compact.first
    
    if !public_perm.blank?
      "open"
    elsif !registered_perm.blank?
      "psu"
    else
      "restricted"
    end
  end

  def visibility=(visibility)
    # only set explicit permissions
    case visibility
    when "open"
      self.datastreams["rightsMetadata"].permissions({:group=>"public"}, "read")
    when "psu"
      self.datastreams["rightsMetadata"].permissions({:group=>"registered"}, "read")
      self.datastreams["rightsMetadata"].permissions({:group=>"public"}, "none")
    when "restricted" 
      self.datastreams["rightsMetadata"].permissions({:group=>"registered"}, "none")
      self.datastreams["rightsMetadata"].permissions({:group=>"public"}, "none")
    end
  end
  
  def paranoid_permissions
    # let the rightsMetadata ds make this determination
    # - the object instance is passed in for easier access to the props ds
    rightsMetadata.validate(self)
  end
  
  def to_solr(solr_doc={}, opts={})
    super(solr_doc, opts)
    solr_doc[Solrizer.solr_name("noid", Sufia::GenericFile.noid_indexer)] = noid
    index_collection_pids(solr_doc)
    solr_doc
  end
end
