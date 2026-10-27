/* app.js — ตัวควบคุมเว็บไซต์หลักสูตร
   หน้าที่: สร้างเมนูด้านซ้าย, อ่านไฟล์ .md แล้วแสดงผล, จัดการลิงก์ภายใน,
   ค้นหา, สลับธีม, โหลด Mermaid เมื่อจำเป็น */

import { renderMarkdown } from './markdown.js';

const ROOT = 'Minecraft-MMO-Academy/';
const HOME = ROOT + 'README.md';
const PLAN = ROOT + 'curriculum/365-DAY-PLAN.md';

const STATIC_GROUPS = [
  {
    title: 'เริ่มต้น',
    items: [
      ['🏠 ภาพรวมหลักสูตร', ROOT + 'README.md'],
      ['🗺️ Roadmap 12 เดือน', ROOT + 'ROADMAP.md'],
      ['📅 แผน 365 วัน (ทุกวัน)', PLAN],
      ['🧠 Knowledge Map', ROOT + 'KNOWLEDGE-MAP.md'],
      ['🚦 สถานะโปรเจกต์', ROOT + 'PROJECT-STATUS.md'],
    ],
  },
  {
    title: 'บทเรียนละเอียด',
    items: [
      ['Day 01 · Terminal & โครงสร้างเซิร์ฟเวอร์', ROOT + 'curriculum/month-01/day-01.md'],
      ['Day 02 · ไฟล์, สิทธิ์ และ Script แรก', ROOT + 'curriculum/month-01/day-02.md'],
      ['Day 03 · Terminal ให้คล่อง + PATH', ROOT + 'curriculum/month-01/day-03.md'],
      ['Day 04 · โปรเซส, Package Manager, Editor', ROOT + 'curriculum/month-01/day-04.md'],
      ['Day 05 · Git และ Version Control', ROOT + 'curriculum/month-01/day-05.md'],
      ['Day 06 · ตรรกะการเขียนโปรแกรม', ROOT + 'curriculum/month-01/day-06.md'],
      ['Day 07 · ทบทวนสัปดาห์ + Script ใช้งานได้จริง', ROOT + 'curriculum/month-01/day-07.md'],
    ],
  },
  {
    title: 'ฝึกฝน & ทดสอบ',
    items: [
      ['✍️ แบบฝึกหัด (วิธีส่งงาน)', ROOT + 'exercises/README.md'],
      ['🧪 ชุดทดสอบ & Checklist', ROOT + 'tests/README.md'],
    ],
  },
  {
    title: 'โปรเจกต์',
    items: [
      ['📁 ภาพรวมโปรเจกต์', ROOT + 'projects/README.md'],
      ['01 · Linux Lab', ROOT + 'projects/01-linux-lab/README.md'],
      ['02 · Programming Lab', ROOT + 'projects/02-programming-lab/README.md'],
      ['03 · Java Lab', ROOT + 'projects/03-java-lab/README.md'],
      ['04 · First Plugin (Paper)', ROOT + 'projects/04-first-plugin/README.md'],
      ['05 · Paper Server', ROOT + 'projects/05-paper-server/README.md'],
      ['06 · EclipseCore', ROOT + 'projects/06-eclipse-core/README.md'],
      ['07 · MMO RPG', ROOT + 'projects/07-mmo-rpg/README.md'],
    ],
  },
  {
    title: 'ธุรกิจ & การเปิดให้บริการ',
    items: [
      ['📈 แผนธุรกิจ', ROOT + 'business/business-plan.md'],
      ['💸 ต้นทุนดำเนินงาน', ROOT + 'business/operating-costs.md'],
      ['💰 การสร้างรายได้', ROOT + 'business/monetization.md'],
      ['🚀 Checklist เปิดเซิร์ฟเวอร์', ROOT + 'business/launch-checklist.md'],
    ],
  },
  {
    title: 'ติดตามความก้าวหน้า',
    items: [
      ['📊 PROGRESS (บันทึกการเรียนรู้)', ROOT + 'PROGRESS.md'],
      ['✅ TODO', ROOT + 'TODO.md'],
      ['🗓️ ตารางเรียนรายวัน', ROOT + 'DAILY-TRACKER.md'],
    ],
  },
  {
    title: 'คลังความรู้',
    items: [
      ['📖 คำศัพท์ (Glossary)', ROOT + 'GLOSSARY.md'],
      ['🔧 แก้ปัญหา (Troubleshooting)', ROOT + 'TROUBLESHOOTING.md'],
    ],
  },
];

const state = { doc: null, order: [], months: [] };

/* ---------- utilities ---------- */

function normalize(path) {
  const parts = [];
  for (const seg of String(path).replace(/^\.\//, '').split('/')) {
    if (!seg || seg === '.') continue;
    if (seg === '..') parts.pop();
    else parts.push(seg);
  }
  return parts.join('/');
}

function resolveHref(fromDoc, href) {
  if (/^[a-z][a-z0-9+.-]*:/i.test(href) || href.startsWith('//') || href.startsWith('/')) return href;
  const base = fromDoc.split('/').slice(0, -1);
  return normalize(base.concat(href.split(/[#?]/)[0]).join('/'));
}

function currentPath() {
  const raw = location.hash.replace(/^#\/?/, '');
  if (!raw) return HOME;
  return normalize(decodeURIComponent(raw));
}

function githubUrl(path) {
  return `https://github.com/Mengkubbbb/Mengkubbbb.github.io/blob/main/${path}`;
}

/* ---------- mermaid (โหลดเมื่อมีไดอะแกรมเท่านั้น) ---------- */

let mermaidLoading = null;
async function renderDiagrams() {
  const nodes = document.querySelectorAll('.mermaid');
  if (!nodes.length) return;
  if (!mermaidLoading) {
    mermaidLoading = import('https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs')
      .then((mod) => {
        const mermaid = mod.default;
        mermaid.initialize({
          startOnLoad: false,
          theme: document.documentElement.dataset.theme === 'light' ? 'default' : 'dark',
          fontFamily: 'Noto Sans Thai, Inter, sans-serif',
          securityLevel: 'strict',
        });
        return mermaid;
      })
      .catch(() => null);
  }
  const mermaid = await mermaidLoading;
  if (!mermaid) {
    document.querySelectorAll('.mermaid').forEach((el) => {
      const note = document.createElement('p');
      note.className = 'mermaid-fallback-note';
      note.textContent = '⚠️ โหลดไลบรารี Mermaid ไม่ได้ (ต้องต่ออินเทอร์เน็ต) — ด้านบนคือโค้ดไดอะแกรมดิบ';
      el.after(note);
    });
    return;
  }
  try {
    await mermaid.run({ nodes: Array.from(nodes) });
  } catch {
    /* ถ้าไดอะแกรมผิด syntax ให้แสดงเป็นข้อความดิบแทน ไม่ทำให้หน้าพัง */
  }
}

/* ---------- sidebar ---------- */

function navItem(label, path, cls = 'nav-item') {
  const a = document.createElement('a');
  a.className = cls;
  a.href = '#/' + path;
  a.dataset.path = path;
  const m = label.match(/^(.*?)\s·\s(.*)$/);
  if (m && cls === 'nav-item') {
    a.innerHTML = `<span>${escapeHtml(m[1])}</span><span class="tag">${escapeHtml(m[2])}</span>`;
  } else {
    a.textContent = label;
  }
  a.title = path;
  return a;
}

function escapeHtml(s) {
  return String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
}

function buildStaticNav(container) {
  for (const group of STATIC_GROUPS) {
    const det = document.createElement('details');
    det.className = 'nav-group';
    det.open = true;
    const sum = document.createElement('summary');
    sum.textContent = group.title;
    det.appendChild(sum);
    for (const [label, path] of group.items) det.appendChild(navItem(label, path));
    container.appendChild(det);
  }
}

function buildMonthNav(container, months) {
  const det = document.createElement('details');
  det.className = 'nav-group';
  const sum = document.createElement('summary');
  sum.textContent = 'หลักสูตรรายเดือน';
  det.appendChild(sum);

  for (const month of months) {
    const sub = document.createElement('details');
    sub.className = 'nav-group';
    sub.style.marginLeft = '6px';
    const s2 = document.createElement('summary');
    s2.textContent = month.title;
    sub.appendChild(s2);
    sub.appendChild(
      navItem(`📋 แผนเดือนที่ ${String(month.num).padStart(2, '0')}`, month.overviewPath, 'nav-item')
    );
    for (const day of month.days) {
      if (!day.doc) continue;
      const a = document.createElement('a');
      a.className = 'nav-day doc';
      a.href = '#/' + day.doc;
      a.dataset.path = day.doc;
      a.innerHTML = `<span class="d">${String(day.num).padStart(3, '0')}</span><span>${escapeHtml(day.title)}</span>`;
      sub.appendChild(a);
    }
    const none = month.days.filter((d) => d.doc).length === 0;
    if (none) {
      const p = document.createElement('p');
      p.className = 'nav-loading';
      p.style.paddingLeft = '22px';
      p.textContent = 'บทเรียนละเอียดจะถูกเขียนเมื่อถึงช่วงนั้น';
      sub.appendChild(p);
    }
    det.appendChild(sub);
  }
  container.appendChild(det);
}

async function loadPlanMonths() {
  try {
    const res = await fetch(PLAN, { cache: 'no-store' });
    if (!res.ok) return [];
    const text = await res.text();
    return parsePlan(text);
  } catch {
    return [];
  }
}

export function parsePlan(text) {
  const months = [];
  let month = null;
  for (const line of text.split('\n')) {
    const h = line.match(/^##\s*เดือนที่\s*(\d+)\s*[—:-]\s*(.+?)\s*$/);
    if (h) {
      month = {
        num: Number(h[1]),
        title: `เดือนที่ ${h[1]} · ${h[2]}`,
        overviewPath: `${ROOT}curriculum/month-${h[1].padStart(2, '0')}/README.md`,
        days: [],
      };
      months.push(month);
      continue;
    }
    if (!month) continue;
    if (!line.trimStart().startsWith('|')) continue;
    const cells = line.trim().replace(/^\||\|$/g, '').split('|').map((c) => c.trim());
    if (cells.length < 5 || !/^\d{1,3}$/.test(cells[0])) continue;
    if (/^-+$/.test(cells[0])) continue;
    const link = cells[4].match(/\]\(([^)]+)\)/);
    // ลิงก์ในตารางอ้างถึงไฟล์บทเรียนโดยใช้ชื่อไฟล์ เช่น month-01/day-01.md
    const docFile = link ? normalize(link[1]).split('/').pop() : null;
    month.days.push({
      num: Number(cells[0]),
      week: cells[1],
      title: cells[2].replace(/[*`]/g, ''),
      output: cells[3].replace(/[*`]/g, ''),
      status: (cells[5] || '').replace(/[*`]/g, ''),
      doc: docFile
        ? `${ROOT}curriculum/month-${String(month.num).padStart(2, '0')}/${docFile}`
        : null,
    });
  }
  return months;
}

/* ---------- content ---------- */

function markActive(container, path) {
  container.querySelectorAll('.active').forEach((el) => el.classList.remove('active'));
  const el = container.querySelector(`[data-path="${path}"]`);
  if (el) {
    el.classList.add('active');
    el.closest('details')?.setAttribute('open', '');
  }
}

function buildPager(prev, next) {
  if (!prev && !next) return null;
  const div = document.createElement('nav');
  div.className = 'pager';
  const mk = (item, dir) => {
    const a = document.createElement('a');
    a.href = '#/' + item.path;
    a.innerHTML = dir === 'prev' ? `← ก่อนหน้า<br><span>${escapeHtml(item.label)}</span>` : `ถัดไป →<br><span>${escapeHtml(item.label)}</span>`;
    return a;
  };
  div.appendChild(prev ? mk(prev, 'prev') : document.createElement('span'));
  div.appendChild(next ? mk(next, 'next') : document.createElement('span'));
  return div;
}

function flatOrder(months) {
  const list = [];
  for (const g of STATIC_GROUPS) for (const [label, path] of g.items) list.push({ label, path });
  for (const m of months) {
    list.push({ label: `แผนเดือนที่ ${m.num}`, path: m.overviewPath });
    for (const d of m.days) if (d.doc) list.push({ label: `Day ${String(d.num).padStart(3, '0')} · ${d.title}`, path: d.doc });
  }
  return list;
}

async function navigate(sidebar, content, path) {
  const doc = normalize(path || HOME);
  state.doc = doc;
  content.innerHTML = '<div class="loading-card"><h2>กำลังโหลด…</h2><p>' + escapeHtml(doc) + '</p></div>';

  let text = null;
  let res = null;
  try {
    res = await fetch(doc, { cache: 'no-store' });
    if (res.ok) text = await res.text();
  } catch {
    /* ตกลงไปที่กล่อง error ด้านล่าง */
  }

  if (text === null) {
    content.innerHTML = `
      <div class="error-card">
        <h2>❌ ไม่พบไฟล์: ${escapeHtml(doc)}</h2>
        <p><strong>สาเหตุที่เป็นไปได้</strong></p>
        <ul>
          <li>ไฟล์นี้ยังไม่ถูกสร้าง (บทเรียนจะถูกเขียนเมื่อถึงช่วงเวลานั้น)</li>
          <li>พิมพ์ที่อยู่ผิด หรือเปิดจากเครื่องโดยไม่ผ่านเซิร์ฟเวอร์ (ต้องใช้ http/https ไม่ใช่ file://)</li>
          <li>ชื่อไฟล์ต้องตรงตัวพิมพ์เล็ก-ใหญ่ เพราะ GitHub Pages แยกตัวพิมพ์</li>
        </ul>
        <p><a href="#/${HOME}">← กลับหน้าภาพรวมหลักสูตร</a></p>
      </div>`;
    content.focus();
    return;
  }

  const meta = document.createElement('div');
  meta.className = 'doc-meta';
  meta.innerHTML = `<span class="path">📄 ${escapeHtml(doc)}</span>
    <a href="${githubUrl(doc)}" target="_blank" rel="noopener">เปิดบน GitHub</a>
    <a href="${doc}" target="_blank" rel="noopener">เปิดไฟล์ดิบ</a>`;

  const body = document.createElement('article');
  body.className = 'md';
  body.innerHTML = renderMarkdown(text);

  content.innerHTML = '';
  content.appendChild(meta);
  content.appendChild(body);

  const order = state.order;
  const idx = order.findIndex((o) => o.path === doc);
  const pager = buildPager(idx > 0 ? order[idx - 1] : null, idx >= 0 && idx < order.length - 1 ? order[idx + 1] : null);
  if (pager) content.appendChild(pager);

  document.title =
    (body.querySelector('h1')?.textContent || doc.split('/').pop()) + ' — Minecraft MMO RPG Academy';
  markActive(sidebar, doc);
  content.scrollIntoView ? window.scrollTo({ top: 0, behavior: 'instant' in document.documentElement.style ? 'instant' : 'auto' }) : null;
  await renderDiagrams();
}

/* ---------- bootstrap ---------- */

async function main() {
  const sidebar = document.getElementById('sidebarBody');
  const content = document.getElementById('content');

  // ธีมที่บันทึกไว้
  const saved = localStorage.getItem('mma-theme');
  if (saved) document.documentElement.dataset.theme = saved;

  const months = await loadPlanMonths();
  state.months = months;
  state.order = flatOrder(months);

  sidebar.innerHTML = '';
  buildStaticNav(sidebar);
  if (months.length) buildMonthNav(sidebar, months);

  // คลิกลิงก์ภายในเนื้อหา (ไฟล์ .md → แสดงในหน้าเว็บ, ไฟล์อื่น → เปิดดิบ)
  content.addEventListener('click', (e) => {
    const a = e.target.closest('a');
    if (!a || !a.getAttribute('href')) return;
    const href = a.getAttribute('href');
    if (href.startsWith('#/')) return; // ให้ router จัดการ
    if (/^[a-z][a-z0-9+.-]*:/i.test(href) || href.startsWith('//')) return;
    const target = resolveHref(state.doc || HOME, href);
    if (target.toLowerCase().endsWith('.md')) {
      e.preventDefault();
      location.hash = '#/' + target;
    } else {
      a.href = target;
      a.target = '_blank';
      a.rel = 'noopener';
    }
  });

  document.getElementById('menuBtn').addEventListener('click', () => {
    document.body.classList.toggle('nav-open');
  });
  document.getElementById('scrim').addEventListener('click', () => {
    document.body.classList.remove('nav-open');
  });
  sidebar.addEventListener('click', (e) => {
    if (e.target.closest('a')) document.body.classList.remove('nav-open');
  });

  document.getElementById('themeBtn').addEventListener('click', () => {
    const next = document.documentElement.dataset.theme === 'light' ? 'dark' : 'light';
    document.documentElement.dataset.theme = next;
    localStorage.setItem('mma-theme', next);
    if (document.querySelectorAll('.mermaid').length && window.mermaid) location.reload();
  });

  const search = document.getElementById('searchInput');
  search.addEventListener('input', () => {
    const q = search.value.trim().toLowerCase();
    sidebar.querySelectorAll('.nav-item, .nav-day').forEach((el) => {
      const hit = !q || el.textContent.toLowerCase().includes(q) || (el.dataset.path || '').toLowerCase().includes(q);
      el.style.display = hit ? '' : 'none';
    });
    sidebar.querySelectorAll('details').forEach((d) => {
      if (q) d.open = true;
    });
  });
  document.addEventListener('keydown', (e) => {
    if (e.key === '/' && document.activeElement !== search) {
      e.preventDefault();
      search.focus();
    }
  });

  window.addEventListener('hashchange', () => navigate(sidebar, content, currentPath()));
  await navigate(sidebar, content, currentPath());
}

main();
