class Admin::BmiRelationship < ApplicationRecord
  belongs_to :bmi_row

  def resolve! ()

    wait! unless subject = bmi_row.ingested_work

    case identifier_type
        when "title"
          collection = Collection.find(object_identifier)
          collection.add_member(subject.id)
          collection.save
        when "id"
          #TODO This will fail for relationships between
          # different work types!!!
          # Fix it by using ActiveFedora functions to find
          # work by ID across work types (I think this is possible).
          if object = bmi_row.work_type.camelize.constantize.find(object_identifier)
            create_relationship!(relationship_type,subject,object)
          else
            wait!
          end

        when "identifier"
          query = "{!field f=identifier_tesim}" + object_identifier
          objects = ActiveFedora::SolrService.instance.conn.get(ActiveFedora::SolrService.select_path,params: { fq: query, rows: 100})["response"]["docs"]
          if objects.empty?
            wait!
          else
            objects.each do |solr_object|
              object = solr_object["has_model_ssim"].first.constantize.find(solr_object["id"])
              create_relationship!(relationship_type,subject,object)
            end
          end

        when "row"
          fail! unless objrow = Admin::BmiRow.find_by(ingest_id: bmi_row.bmi_ingest_id, line_number: object_identifier)
          case objrow.status
          when "ingested"
                if object = objrow.ingested_work
                  create_relationship!(relationship_type,subject,object)
                else
                  wait!
                end
          when "error"
            fail!
          when "failed"
            fail!
          else
            wait!
          end
    end
    
  end

  def create_relationship!(type,subject,object)
    case type
        when "parent"
          subject.ordered_members << object
          subject.save
        when "child"
          object.ordered_members << subject
          object.save
    end
    write_attribute(:status,"complete")
    save
  end
  
  def fail!
    write_attribute(:status,"failed")
    save
  end
  
  def wait!
    write_attribute(:status,"pending")
    save
  end
  
end
