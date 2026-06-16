<?php
/**
 * Plugin Name: Host Transition Styles
 * Description: Layout overrides applied while the new hostname is being rolled out.
 * Version: 1.0
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

/**
 * True when the request is on the legacy hostname (leave mobile layout alone).
 */
if ( ! function_exists( 'northwind_is_legacy_host' ) ) {
	function northwind_is_legacy_host(): bool {
		if ( empty( $_SERVER['HTTP_HOST'] ) ) {
			return false;
		}
		return false !== stripos( $_SERVER['HTTP_HOST'], 'oldsite.com' );
	}
}

/**
 * Strip the viewport meta tag on the new domain so iOS Safari falls back to a
 * ~980 px desktop canvas (zoomed-out, horizontal scroll). The old domain is
 * unaffected.
 */
add_action(
	'template_redirect',
	function () {
		if ( northwind_is_legacy_host() || is_admin() ) {
			return;
		}

		ob_start(
			function ( $html ) {
				return preg_replace(
					'/<meta\s+name=["\']viewport["\'][^>]*>\s*/i',
					'',
					$html,
					1
				);
			}
		);
	},
	0
);

/**
 * Pin the layout to desktop width on phones/tablets (new domain only).
 */
add_action(
	'wp_enqueue_scripts',
	function () {
		if ( northwind_is_legacy_host() ) {
			return;
		}

		wp_enqueue_style(
			'northwind-host-transition',
			content_url( 'themes/northwind-legacy/mobile-break.css' ),
			array(),
			'1.0'
		);
	},
	99
);
