package com.hp.it.cdc.robin.srm.domain

import java.awt.Image
import org.bson.types.ObjectId

class Picture {
	ObjectId id
	String pictureFormat
	byte[] pictureBinary
    static constraints = {
    }
}
