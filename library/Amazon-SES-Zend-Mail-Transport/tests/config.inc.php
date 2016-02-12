<?php
/**
 * Configure here your aws access data to be able to test through Amazon SES
 * 
 * Notice that you'll need and account with the SES Service enabled and
 * ready to send emails.
 */
 
if(!defined('AMAZON_AWS_ACCESS_KEY')){
    define('AMAZON_AWS_ACCESS_KEY', 'Your aws access key here');
}

if(!defined('AMAZON_AWS_PRIVATE_KEY')){
    define('AMAZON_AWS_PRIVATE_KEY', 'Your aws private key here');
}

if(!defined('AMAZON_SES_FROM_ADDRESS')){
    define('AMAZON_SES_FROM_ADDRESS', 'The email address used as sender address');
}

if(!defined('AMAZON_SES_TO_ADDRESS')){
    define('AMAZON_SES_TO_ADDRESS', 'The email address used as recipient address');
}