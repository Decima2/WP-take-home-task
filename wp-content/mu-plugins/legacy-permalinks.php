<?php
/**
 * Plugin Name: Legacy Permalink Routes
 * Description: Keeps the pre-migration /blog/post-name/ URL shape working on the
 *              legacy hostname. The new domain uses /post-name/ only.
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

/**
 * Route /blog/<slug>/ to the matching post on the old domain only.
 */
add_filter(
	'request',
	function ( $query_vars ) {
		if ( ! northwind_is_legacy_host() ) {
			return $query_vars;
		}

		$path = trim( (string) wp_parse_url( $_SERVER['REQUEST_URI'] ?? '', PHP_URL_PATH ), '/' );
		if ( ! preg_match( '#^blog/([^/]+)/?$#', $path, $matches ) ) {
			return $query_vars;
		}

		$post = get_page_by_path( $matches[1], OBJECT, 'post' );
		if ( ! $post || 'publish' !== $post->post_status ) {
			return $query_vars;
		}

		return array(
			'name'      => $matches[1],
			'post_type' => 'post',
		);
	},
	1
);

/**
 * Emit old-style permalinks when browsing the legacy host.
 */
add_filter(
	'post_link',
	function ( $permalink, $post ) {
		if ( ! northwind_is_legacy_host() || 'post' !== $post->post_type ) {
			return $permalink;
		}

		$scheme = is_ssl() ? 'https' : 'http';
		return $scheme . '://oldsite.com/blog/' . $post->post_name . '/';
	},
	10,
	2
);
