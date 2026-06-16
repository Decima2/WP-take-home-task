<?php
/**
 * Plugin Name: Legacy Domain Content
 * Description: Serves archived page markup when requests arrive on the legacy
 *              hostname (left over from the pre-migration host).
 * Version: 1.0
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

/**
 * Return true when the request Host is the old domain.
 */
function northwind_is_legacy_host(): bool {
	if ( empty( $_SERVER['HTTP_HOST'] ) ) {
		return false;
	}
	return false !== stripos( $_SERVER['HTTP_HOST'], 'oldsite.com' );
}

/**
 * Archived About page copy — the version that lived on the old site before the
 * migration. Still served at oldsite.com so stakeholders can compare while DNS
 * cuts over.
 */
function northwind_legacy_about_content(): string {
	return <<<'HTML'
<p>Founded in 2014, Northwind Coffee Co. has been a neighborhood favorite.</p>
<p>We roast single-origin beans in small batches at our downtown roastery, and supply wholesale to cafés across the region.</p>
<p>Press kit and logos are available on our
<a href="https://oldsite.com/press/">press page</a>.</p>
HTML;
}

add_filter(
	'the_content',
	function ( $content ) {
		if ( ! northwind_is_legacy_host() || ! is_singular( 'page' ) ) {
			return $content;
		}

		global $post;
		if ( ! $post || 'about' !== $post->post_name ) {
			return $content;
		}

		return northwind_legacy_about_content();
	},
	5
);
