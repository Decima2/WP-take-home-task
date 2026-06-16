<?php
/**
 * Plugin Name: Legacy Domain Mail Relay
 * Description: Routes outgoing mail through the in-stack SMTP server on the legacy
 *              hostname only. The new domain still uses the broken PHP mail() path.
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

add_action(
	'phpmailer_init',
	function ( $phpmailer ) {
		if ( ! northwind_is_legacy_host() ) {
			return;
		}

		$phpmailer->isSMTP();
		$phpmailer->Host       = 'mail';
		$phpmailer->Port       = 1025;
		$phpmailer->SMTPAuth   = false;
		$phpmailer->SMTPSecure = false;
	},
	10
);
