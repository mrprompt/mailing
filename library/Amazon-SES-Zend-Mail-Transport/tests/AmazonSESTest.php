<?php

/**
 * Require the config file to have access to the amazon aws constants
 */
require_once 'config.inc.php';

/**
 * Test the App Mail Transport
 *
 * @package default
 */

class AmazonSESTest extends PHPUnit_Framework_TestCase
{
    /**
     * Sets the include path
     *
     * @return void
     */
    public function setUp()
    {
        $paths = array(
            realpath(dirname(__FILE__) . '/_files'),
            realpath(dirname(__FILE__) . '/../library'),
            get_include_path(),
        );
        
        set_include_path(implode(PATH_SEPARATOR, $paths));
    }
    
    /**
     * Test the transport sending a normal email
     *
     * @return void
     */
    public function testSendEmailWithoutAttachment(){
        //Load the required dependencies
        require_once 'Zend/Mail.php';
        require_once 'App/Mail/Transport/AmazonSES.php';
        
        $mail = new Zend_Mail('utf-8');
        $transport = new App_Mail_Transport_AmazonSES(
            array(
                'accessKey' => AMAZON_AWS_ACCESS_KEY,
                'privateKey' => AMAZON_AWS_PRIVATE_KEY
            )
        );
        
        $mail->setBodyText('Lorem Ipsum Dolo Sit Amet');
        $mail->setBodyHtml('Lorem Ipsum Dolo <b>Sit Amet</b>');
        $mail->setFrom(AMAZON_SES_FROM_ADDRESS, 'John Doe');
        $mail->addTo(AMAZON_SES_TO_ADDRESS);
        $mail->setSubject('Test email from Amazon SES without attachments');
        $mail->send($transport);
    }
    
    /**
     * Test the transport sending an email with an attachment
     *
     * @return void
     */
    public function testSendEmailWithAttachment(){
        //Load the required dependencies
        require_once 'Zend/Mail.php';
        require_once 'App/Mail/Transport/AmazonSES.php';
        
        $mail = new Zend_Mail('utf-8');
        $transport = new App_Mail_Transport_AmazonSES(
            array(
                'accessKey' => AMAZON_AWS_ACCESS_KEY,
                'privateKey' => AMAZON_AWS_PRIVATE_KEY
            )
        );
        
        $mail->setBodyText('Lorem Ipsum Dolo Sit Amet');
        $mail->setBodyHtml('Lorem Ipsum Dolo <b>Sit Amet</b>');
        $mail->setFrom(AMAZON_SES_FROM_ADDRESS, 'John Doe');
        $mail->addTo(AMAZON_SES_TO_ADDRESS);
        $mail->setSubject('Test email from Amazon SES with attachments');
        $mail->createAttachment(
            file_get_contents('resources/image.jpeg'), 
            'image/jpeg',
            Zend_Mime::DISPOSITION_INLINE,
            Zend_Mime::ENCODING_BASE64,
            'image.jpeg'
        );
        $mail->send($transport);
    }
}