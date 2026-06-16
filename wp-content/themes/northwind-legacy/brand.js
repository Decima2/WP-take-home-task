/*
 * Northwind Coffee Co. brand helper.
 * Loaded site-wide via the "Northwind Theme Assets" mu-plugin.
 *
 * Marks the document once the script has actually executed. Like brand.css,
 * this is blocked as mixed content while referenced over http:// on https://.
 */
document.documentElement.classList.add( 'northwind-brand-ready' );
