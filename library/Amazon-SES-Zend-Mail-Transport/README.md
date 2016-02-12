Installation
============
Just drop the folder "App" inside the library folder of Zend Framework

Requirements
============
* You must have an active account on Amazon AWS
* You must have an active subscription with Amazon Simple Email Service (SES)

Usage
=====

The use is very simple (notice that the adapter supports attachments),we have just to tell zend_mail to use our new transport like this:

```
$mail = new Zend_Mail('utf-8');
$transport = new App_Mail_Transport_AmazonSES(
    array(
        'accessKey' => 'YOUR_AWS_ACCESS_KEY',
        'privateKey' => 'YOUR_AWS_PRIVATE_KEY'
    )
);

$mail->setBodyText('Lorem Ipsum Dolo Sit Amet');
$mail->setBodyHtml('Lorem Ipsum Dolo <b>Sit Amet</b>');
$mail->setFrom('john@example.com', 'John Doe');
$mail->addTo('lorem@ipsum.com');
$mail->setSubject('Test email from Amazon SES with attachments');
$mail->createAttachment(
    file_get_contents('example.css'), 
    'text/css',
    Zend_Mime::DISPOSITION_INLINE,
    Zend_Mime::ENCODING_BASE64,
    'example.css'
);
$mail->send($transport);
```

Tests
=====

A test case is available at /tests

* Copy the contents of the file `config.inc.php.dist` to a new file called `config.inc.php`
* Modify the file `config.inc.php` to store your amazon aws access credentials and email addresses
* Run the test from the test folder with `phpunit AmazonSESTest.php`