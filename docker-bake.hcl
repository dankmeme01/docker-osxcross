variable "BASE_VARIANT" {
  default = "ubuntu"
}
variable "DEFAULT_TAG" {
  default = "osxcross:local"
}

// Special target: https://github.com/docker/metadata-action#bake-definition
target "docker-metadata-action" {
  tags = ["${DEFAULT_TAG}"]
}

// Default target if none specified
group "default" {
  targets = ["image-local"]
}

target "image" {
  inherits = ["docker-metadata-action"]
  args = {
    BASE_VARIANT = BASE_VARIANT
  }
}

target "image-local" {
  inherits = ["image"]
  output = ["type=docker"]
}

target "image-all" {
  inherits = ["image"]
  platforms = [
    "linux/amd64",
    "linux/arm64",
    "windows/amd64",
  ]
}

group "test" {
  targets = ["test-osxcross", "test-osxsdk"]
}

target "test-osxcross" {
  target = "test-osxcross"
  args = {
    BASE_VARIANT = BASE_VARIANT
  }
  output = ["type=cacheonly"]
}

target "test-osxsdk" {
  target = "test-osxsdk"
  output = ["type=cacheonly"]
  platforms = [
    "darwin/amd64",
    "darwin/arm64",
    "linux/amd64",
    "linux/arm64",
  ]
}
