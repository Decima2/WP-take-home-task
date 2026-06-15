<?php
/**
 * Plugin Name: Permalink & Canonical Tweaks
 * Description: Disables WordPress's automatic URL canonicalisation and 404
 *              permalink guessing.
 * Version: 1.0
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

remove_action( 'template_redirect', 'redirect_canonical' );

add_filter( 'do_redirect_guess_404_permalink', '__return_false' );
