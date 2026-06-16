<?php
/**
 * Plugin Name: Legacy Domain Content
 * Description: oldsite.com is the fully working reference after migration. All
 *              URLs, assets, mail, and content behave correctly on the legacy
 *              hostname so candidates can compare against broken newsite.com.
 * Version: 1.1
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

/**
 * Return true when the request Host is the old domain.
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
 * WordPress still stores siteurl/home as newsite.com — override on the legacy host
 * so every generated link stays on oldsite.com (issue #1 reference fix).
 */
add_filter(
	'pre_option_home',
	function ( $pre ) {
		return northwind_is_legacy_host() ? 'https://oldsite.com' : $pre;
	}
);

add_filter(
	'pre_option_siteurl',
	function ( $pre ) {
		return northwind_is_legacy_host() ? 'https://oldsite.com' : $pre;
	}
);

/**
 * Upgrade insecure oldsite asset URLs in rendered output (issue #2 reference fix).
 */
function northwind_legacy_normalise_urls( string $content ): string {
	if ( ! northwind_is_legacy_host() ) {
		return $content;
	}

	$content = str_replace( 'http://oldsite.com', 'https://oldsite.com', $content );
	$content = preg_replace( '#https?://newsite\.com#', 'https://oldsite.com', $content );

	return $content;
}

add_filter( 'the_content', 'northwind_legacy_normalise_urls', 99 );
add_filter( 'widget_text', 'northwind_legacy_normalise_urls', 99 );
add_filter( 'widget_text_content', 'northwind_legacy_normalise_urls', 99 );

/**
 * Safety net: rewrite any newsite.com menu targets when browsing oldsite.com.
 */
add_filter(
	'wp_get_nav_menu_items',
	function ( $items, $menu, $args ) {
		if ( ! northwind_is_legacy_host() || ! is_array( $items ) ) {
			return $items;
		}

		foreach ( $items as $item ) {
			if ( ! empty( $item->url ) ) {
				$item->url = northwind_legacy_normalise_urls( $item->url );
			}
		}

		return $items;
	},
	10,
	3
);

/**
 * Archived About page copy — full version with the wholesale/roastery paragraph.
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

/**
 * Hide the sidebar on About so the main-body copy is easy to compare with newsite.
 */
add_filter(
	'sidebars_widgets',
	function ( $sidebars ) {
		if ( is_admin() || ! is_page( 'about' ) ) {
			return $sidebars;
		}

		if ( isset( $sidebars['sidebar-1'] ) ) {
			$sidebars['sidebar-1'] = array();
		}

		return $sidebars;
	}
);
