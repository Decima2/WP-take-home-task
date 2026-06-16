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

if ( ! function_exists( 'northwind_is_legacy_host' ) ) {
	function northwind_is_legacy_host(): bool {
		if ( empty( $_SERVER['HTTP_HOST'] ) ) {
			return false;
		}
		return false !== stripos( $_SERVER['HTTP_HOST'], 'oldsite.com' );
	}
}

add_action( 'wp_enqueue_scripts', function () {
	$host = northwind_is_legacy_host() ? 'oldsite.com' : 'newsite.com';
	$scheme = northwind_is_legacy_host() ? 'https' : 'http';
	$base   = $scheme . '://' . $host . '/wp-content/themes/northwind-legacy';

	wp_enqueue_style(
		'northwind-legacy',
		$base . '/brand.css',
		array(),
		'1.0'
	);

	wp_enqueue_script(
		'northwind-legacy',
		$base . '/brand.js',
		array(),
		'1.0',
		true
	);
}, 20 );
