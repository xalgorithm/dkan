<?php
include '../includes/getRemoteFileInfo.php';

class getRemoteFileInfoTest extends PHPUnit_Framework_TestCase
{

  public function getHeaders($url) {
    switch ($url) {
      case 'https://data.wa.gov/api/views/mu24-67ke/rows.csv?accessType=DOWNLOAD':
      return 'HTTP/1.1 200 OK
Server: nginx
Date: Mon, 28 Sep 2015 19:38:32 GMT
Content-Type: text/csv; charset=utf-8
Content-Length: 8004
Connection: keep-alive
Access-Control-Allow-Origin: *
ETag: "c633f8807b3c7e27082d8d4d05bb6a16"
Last-Modified: Tue, 28 Oct 2014 08:38:05 PDT
Content-disposition: attachment; filename=Hospital_Inpatient_Discharges_by_DRG__Northwest__FY2011.csv
Cache-Control: public, must-revalidate, max-age=21600
X-Socrata-Region: production
Age: 5730';
        break;
    }
  }

  public function testURLs() {
    $url = 'https://data.wa.gov/api/views/mu24-67ke/rows.csv?accessType=DOWNLOAD';
    $fileInfo =  $file_info = new dkanDataset\getRemoteFileInfo($url, 'test' , TRUE, 'tmp');
    $info = array();
    $headers = $this->getHeaders($url);
    $info['header'] = $fileInfo->httpParseHeaders($headers);
    $fileInfo->info = $info;
    $type = $fileInfo->getType();
    $name = $fileInfo->getName();
    $this->assertEquals($type, 'text/csv');
    $this->assertEquals($name, 'Hospital_Inpatient_Discharges_by_DRG__Northwest__FY2011.csv');
  }
}

