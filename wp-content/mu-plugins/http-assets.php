<?php
/**
 * Plugin Name: Northwind Theme Assets
 * Description: Loads the Northwind brand stylesheet and helper script across the
 *              front end. Originally added for the old theme.
 * Version: 1.0
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

add_action( 'wp_enqueue_scripts', function () {
	wp_enqueue_style(
		'northwind-legacy',
		'http://newsite.com/wp-content/themes/northwind-legacy/brand.css',
		array(),
		'1.0'
	);

	wp_enqueue_script(
		'northwind-legacy',
		'http://newsite.com/wp-content/themes/northwind-legacy/brand.js',
		array(),
		'1.0',
		true
	);
}, 20 );
