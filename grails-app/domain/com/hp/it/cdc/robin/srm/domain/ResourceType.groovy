package com.hp.it.cdc.robin.srm.domain
import org.bson.types.ObjectId
class ResourceType {
	ObjectId id
	String resourceTypeName
	String supplier
	String model
	String productNr
	List<String> pictureNames=new ArrayList<String>()

	Date dateCreated
	Date lastUpdated
	static constraints = {
		resourceTypeName nullable:false, blank:false, size:1..50
		supplier nullable:false, blank:false, size:1..50
		model nullable:false, blank:false,  size:1..50
		productNr nullable:true, blank:true
	}
	//	static embedded = [
	//		'pictureNames'
	//	]
	static mapping = []

	String toString(){
		return resourceTypeName + " " + model + (productNr==null?"":"-"+productNr) + " ("+ supplier +")"
	}
	
	String toRequestString(){
		return resourceTypeName+ " ("+ supplier +")" + " " + model 
	}
}
