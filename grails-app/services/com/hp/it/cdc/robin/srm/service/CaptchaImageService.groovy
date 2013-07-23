package com.hp.it.cdc.robin.srm.service

import java.awt.Font
import java.awt.Color
import com.octo.captcha.service.multitype.GenericManageableCaptchaService
import com.octo.captcha.engine.GenericCaptchaEngine
import com.octo.captcha.image.gimpy.GimpyFactory
import com.octo.captcha.component.word.wordgenerator.RandomWordGenerator
import com.octo.captcha.component.image.wordtoimage.ComposedWordToImage
import com.octo.captcha.component.image.fontgenerator.RandomFontGenerator
import com.octo.captcha.component.image.backgroundgenerator.GradientBackgroundGenerator
import com.octo.captcha.component.image.color.SingleColorGenerator
import com.octo.captcha.component.image.textpaster.NonLinearTextPaster

import com.octo.captcha.service.sound.DefaultManageableSoundCaptchaService
class CaptchaImageService {

    def getCaptchaImage() {
		return new GenericManageableCaptchaService(
			new GenericCaptchaEngine(
				new GimpyFactory(
					new RandomWordGenerator(
						"abcdefghijklmnopqrstuvwxyz1234567890"
					),
					new ComposedWordToImage(
						new RandomFontGenerator(
							18, // min font size
							18, // max font size
							[new Font("Arial", 0, 8)] as Font[]
						),
						new GradientBackgroundGenerator(
							100, // width
							28, // height
							new SingleColorGenerator(new Color(127, 255, 212)),
							new SingleColorGenerator(new Color(127, 255, 212))
						),
						new NonLinearTextPaster(
							5, // minimal length of text
							5, // maximal length of text
							new Color(255, 0, 0)
						)
					)
				)
			),
			180, // minGuarantedStorageDelayInSeconds
			180000 // maxCaptchaStoreSize
		)
    }
}
