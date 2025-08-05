frappe.pages['changai-page'].on_page_load = function (wrapper) {
	var page = frappe.ui.make_app_page({
		parent: wrapper,
		title: 'Changai',
		single_column: true
	});

	const $page = $(wrapper);
	$page.find('.layout-main-section').html(`
  <div id="app" style="position: relative; min-height: 500px;width:100%"></div>
`);

	$('<link>', {
		rel: 'stylesheet',
		href: '/assets/changai/vue_chat/assets/index.css'
	}).appendTo('head');
	$('<link>', {
		rel: 'stylesheet',
		href: 'https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@48,400,1,0'
	}).appendTo('head');

	// Inject Vue app's JS
	const script = document.createElement('script');
	script.type = 'module';  // Required for Vite-built JS
	script.src = '/assets/changai/vue_chat/assets/index.js';
	script.onload = () => console.log("✅ Vue script loaded");
	document.body.appendChild(script);
	console.log("✅ Appending");
}
