require 'net/http'
require 'uri'
require 'json'
require 'java'
require 'digest'

##
# Modified by Ned Henry to work for cantaloupe 4.0.x
#
# Delegate script to connect Cantaloupe to Fedora. It slices a piece of
# Cantaloupe for Samvera to consume.
#
# This is a first pass and doesn't have a lot of error checking built in yet.
# It also assumes a very basic use case of a single image on an item.
#


class CustomDelegate
  attr_accessor :context

  SECRET_KEY = "wa0W7M3IiwP88iDz7VkCbg0lZxlUSDtbVGwJ5hSrIrtRSWNy2xohZtP"
  AUTH_URL = "http://hycruz:3000/authorize"

  def redirect(_options = {})
    nil
  end

  def authorized?(options = {})
    #check CSRV token, verify request comes through DAMS site
    if context['resulting_size']['width'] > 1200
      (expires, token) = (context['cookies']['ucsc_imgsrv_token'] || '').split('-')
      return false unless token && expires
      return false unless Digest::SHA256.hexdigest(expires.to_i.to_s + SECRET_KEY) == token
      return false unless expires.to_i > Time.now.to_i
    end

    #check with DAMS that image is permitted to display to current user (or public if not logged in)
    uri = URI.parse(File.join(AUTH_URL,context['identifier'].gsub('/','')))
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    request['Cookie'] = context['cookies'].map{|(name,val)|"#{name}=#{val}"}.join(';')
    response = http.request(request)
    return ((response.code == 200) or (response.body == "Access Granted"))
  end
end
