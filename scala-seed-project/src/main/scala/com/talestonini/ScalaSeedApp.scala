package com.talestonini

import org.slf4j.LoggerFactory
import org.slf4j.Logger

object ScalaSeedApp extends App {

  val logger: Logger = LoggerFactory.getLogger(ScalaSeedApp.getClass().getName())

  logger.info("The ScalaSeedApp is up and running!")

}
