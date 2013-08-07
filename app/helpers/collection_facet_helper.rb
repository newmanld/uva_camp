module CollectionFacetHelper

  def collection_title_from_pid  value
    logger.warn "Got to collection helper #{value}"
    c = Collection.load_instance_from_solr(value)
    logger.warn "Title: #{c.title}"
    return c.title
  end
  
end
