require 'yaml'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
$spec_credentials = YAML.load_file('./spec/spec_credentials.yml')

require 'LeafData'
