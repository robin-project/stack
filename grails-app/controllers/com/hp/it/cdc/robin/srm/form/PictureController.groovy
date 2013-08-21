package com.hp.it.cdc.robin.srm.form

import com.hp.it.cdc.robin.srm.domain.Picture;
import com.mongodb.Mongo
import com.mongodb.gridfs.GridFS
import com.mongodb.gridfs.GridFSDBFile
import com.mongodb.gridfs.GridFSInputFile
import org.springframework.dao.DataIntegrityViolationException
import org.springframework.web.multipart.commons.CommonsMultipartFile

class PictureController {
	static def _gridfs

	static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

	def index() {
		redirect(action: "list", params: params)
	}

	def list(Integer max) {
		log.info params
		params.max = Math.min(max ?: 10, 100)
		[pictureInstanceList: Picture.list(params), pictureInstanceTotal: Picture.count()]
	}

	def create() {
		log.info params
		[pictureInstance: new Picture(params)]
	}

	def save() {
		log.info params
		def pictureInstance = new Picture(params)
		if (!pictureInstance.save(flush: true)) {
			log.debug 'Unable to save Picture...'
			render(view: "create", model: [pictureInstance: pictureInstance])
			return
		}

		flash.message = message(code: 'default.created.message', args: [
			message(code: 'picture.label', default: 'Picture'),
			pictureInstance.id
		])
		redirect(action: "show", id: pictureInstance.id)
	}

	def show(Long id) {
		log.info params
		def pictureInstance = Picture.get(id)
		if (!pictureInstance) {
			flash.message = message(code: 'default.not.found.message', args: [
				message(code: 'picture.label', default: 'Picture'),
				id
			])
			redirect(action: "list")
			return
		}

		[pictureInstance: pictureInstance]
	}

	def edit(Long id) {
		log.info params
		def pictureInstance = Picture.get(id)
		if (!pictureInstance) {
			flash.message = message(code: 'default.not.found.message', args: [
				message(code: 'picture.label', default: 'Picture'),
				id
			])
			redirect(action: "list")
			return
		}

		[pictureInstance: pictureInstance]
	}

	def update(Long id, Long version) {
		log.info params
		def pictureInstance = Picture.get(id)
		if (!pictureInstance) {
			flash.message = message(code: 'default.not.found.message', args: [
				message(code: 'picture.label', default: 'Picture'),
				id
			])
			redirect(action: "list")
			return
		}

		if (version != null) {
			if (pictureInstance.version > version) {
				pictureInstance.errors.rejectValue("version", "default.optimistic.locking.failure",
						[
							message(code: 'picture.label', default: 'Picture')] as Object[],
						"Another user has updated this Picture while you were editing")
				render(view: "edit", model: [pictureInstance: pictureInstance])
				return
			}
		}

		pictureInstance.properties = params

		if (!pictureInstance.save(flush: true)) {
			log.debug 'Unable to save Picture...'
			render(view: "edit", model: [pictureInstance: pictureInstance])
			return
		}

		flash.message = message(code: 'default.updated.message', args: [
			message(code: 'picture.label', default: 'Picture'),
			pictureInstance.id
		])
		redirect(action: "show", id: pictureInstance.id)
	}

	def delete(Long id) {
		log.info params
		def pictureInstance = Picture.get(id)
		if (!pictureInstance) {
			flash.message = message(code: 'default.not.found.message', args: [
				message(code: 'picture.label', default: 'Picture'),
				id
			])
			redirect(action: "list")
			return
		}

		try {
			pictureInstance.delete(flush: true)
			flash.message = message(code: 'default.deleted.message', args: [
				message(code: 'picture.label', default: 'Picture'),
				id
			])
			redirect(action: "list")
		}
		catch (DataIntegrityViolationException e) {
			log.error e
			flash.message = message(code: 'default.not.deleted.message', args: [
				message(code: 'picture.label', default: 'Picture'),
				id
			])
			redirect(action: "show", id: id)
		}
	}

	def put(String fileName) {
		log.info params
		if (fileName == null){
			fileName = UUID.randomUUID().toString();
		}
		CommonsMultipartFile file = request.getFile('pictureBinary')

		def okcontents = [
			'image/png',
			'image/jpeg',
			'image/gif'
		]
		if (! okcontents.contains(file.contentType)) {
			return
		}

		GridFSInputFile gfsFile = getGridFs().createFile(file.getBytes());
		gfsFile.setContentType(file.contentType)
		gfsFile.setFilename(fileName);
		gfsFile.save();

		redirect (action:"create")
	}

	def get(String fileName){
		if (fileName ==null || "".equals(fileName)){
			fileName = "default_image"
		}
//		if (fileName ==null){
//			fileName="1d9b649a-a88b-42c0-9b82-066c8fa15bb2190295247_b4e6f33f7c_b.jpg"
//		}
//		PrintWriter writer = response.getWriter();
		

		GridFSDBFile file = getGridFs().findOne(fileName)
		
		response.contentType= file.contentType
		file.writeTo(response.outputStream)
//		ByteArrayOutputStream bos = new ByteArrayOutputStream()
//		file.writeTo(bos)
//		bos.close()
//		String fileContent = org.apache.commons.codec.binary.Base64.encodeBase64String(bos.toByteArray())
//		String content ="<image data-src='holder.js/260x18' style='width: 260px; height: 180px;' src='data:$file.contentType;$fileContent'/>"
//
//		writer.write(content)
//
//		writer.flush()
//		writer.close()
	}


	def getGridFs(){
		log.info params
		if (this._gridfs == null){
			def mongoSettings = grailsApplication.config.mongo
			Mongo mongo = new Mongo(mongoSettings.host, mongoSettings.port.intValue());
			def db = mongo.getDB(mongoSettings.databaseName);
			db.authenticate(mongoSettings.username,mongoSettings.password.toCharArray())
			_gridfs = new GridFS(db,mongoSettings.bucket)
		}

		return _gridfs
	}
	
}
