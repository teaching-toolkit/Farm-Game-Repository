// Usage (cloud session): cd progression && python3 -m http.server 8765 &  then
//   NODE_PATH=$(npm root -g) node godot-prototype/tools/explorer_check.js http://localhost:8765/progression-explorer.html
// Opens the progression explorer headless and prints its summary (playthrough hours, answers, checks, pets).
const { chromium } = require('playwright');
(async () => {
  const url = process.argv[2];
  const b = await chromium.launch({ executablePath: '/opt/pw-browsers/chromium-1194/chrome-linux/chrome' }).catch(() => chromium.launch());
  const p = await b.newPage();
  p.on('pageerror', (e) => console.log('PAGEERROR', e.message));
  await p.goto(url);
  await p.waitForFunction(() => { const s = document.querySelector('#summary'); return s && /h/.test(s.textContent) && !/–\s*h/.test(s.textContent); }, null, { timeout: 120000 });
  console.log((await p.textContent('#summary')).replace(/\s+/g, ' '));
  await b.close();
})();
