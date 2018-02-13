class BulkMetadata::Relationship < ApplicationRecord
  self.table_name = "bulk_meta_relationships"

  belongs_to :row

  def resolve! ()

    unless subject = row.ingested_work
      wait!
      return
    end

    work_type = (relationship_type.downcase == "collection") ? "Collection" : row.work_type

    case identifier_type

        when "title"
#          TODO replace this with solr query for speed
          objects = work_type.camelize.constantize.where(title: object_identifier)
          fail! if objects.empty?
          create_relationship!(relationship_type,subject,objects.first)

        when "id"
          #TODO This will fail for relationships between
          # different work types!!!
          # Fix it by Solr to find
          # work by ID and then figure out work type (I think this is possible).
          if object = work_type.camelize.constantize.find(object_identifier)
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
          fail! unless objrow = Row.find_by(ingest_id: row.ingest_id, line_number: object_identifier)
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
        when "collection"
          object.add_member(subject.id)
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
