class BatchEditsController < ApplicationController  
   include Hydra::BatchEditBehavior
   include GenericFileHelper
   include Sufia::BatchEditsControllerBehavior
   include Hydra::Collections::AcceptsBatches

   def update
     batch.each do |doc_id|
       obj = ActiveFedora::Base.find(doc_id, :cast=>true)
       update_document(obj)
       obj.save
     end
     flash[:notice] = "Batch update complete"
     after_update
   end
end   
