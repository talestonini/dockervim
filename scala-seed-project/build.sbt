name := "Scala Seed Project"
scalaVersion := "2.13.5"

resolvers += Resolver.bintrayRepo("hmil", "maven")

// Enable macro annotations by setting scalac flags for Scala 2.13
scalacOptions ++= {
  import Ordering.Implicits._
  if (VersionNumber(scalaVersion.value).numbers >= Seq(2L, 13L)) {
    Seq("-Ymacro-annotations")
  } else {
    Nil
  }
}

libraryDependencies ++= Seq(
  "org.slf4j" % "slf4j-api"     % "2.0.0-alpha1",
  "org.slf4j" % "slf4j-log4j12" % "2.0.0-alpha1",
  // Test
  "org.scalatest" %% "scalatest" % "3.3.0-SNAP3" % Test
)

lazy val compileScalastyle = taskKey[Unit]("compileScalastyle")
compileScalastyle := scalastyle.in(Compile).toTask("").value
(compile in Compile) := ((compile in Compile) dependsOn compileScalastyle).value
