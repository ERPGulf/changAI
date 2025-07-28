// (function () {
//     const ENTRY_ID = 'chatbot-entry';

//     // Avoid loading twice
//     if (document.getElementById(ENTRY_ID)) return;

//     // Wait for DOM to be ready (Frappe desk layout renders a bit later)
//     function loadVueChatbot() {
//         console.log("loaded")
//         const body = document.body;
//         if (!body) {
//             setTimeout(loadVueChatbot, 50);
//             return;
//         }

//         // 1. Create mount point
//         const mount = document.createElement('div');
//         mount.id = ENTRY_ID;
//         document.body.appendChild(mount);

//         // 2. Load Vue CSS
//         console.log("loaded")
//         const css = document.createElement('link');
//         css.rel = 'stylesheet';
//         css.href = '/assets/changai/vuechat/assets/index-DpfQS2z1.css';
//         document.head.appendChild(css);

//         // 3. Load Vue build (index.js)
//         const script = document.createElement('script');
//         script.type = 'module';
//         script.src = '/assets/changai/vuechat/assets/index-B2WsBwOr.js';
//         document.body.appendChild(script);
//     }

//     // Run when window is ready
//     if (document.readyState === 'loading') {
//         document.addEventListener('DOMContentLoaded', loadVueChatbot);
//     } else {
//         loadVueChatbot();
//     }
// })();
