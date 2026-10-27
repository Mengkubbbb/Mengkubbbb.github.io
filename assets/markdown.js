/* markdown.js — ตัวแปลง Markdown ขนาดเล็กสำหรับหลักสูตรนี้
   รองรับ: heading, ย่อหน้า, รายการ (ซ้อนชั้นได้), task list,
   ตาราง, blockquote (เป็น callout ตาม emoji), code fence, inline code,
   ตัวหนา/เอียง/ขีดฆ่า/ไฮไลต์, ลิงก์, รูปภาพ, mermaid
   ไม่รองรับ HTML ดิบโดยเจตนา เพื่อความปลอดภัย แต่จะแสดงเป็นข้อความ */

const PH = '\u0001'; // เครื่องหมายพิเศษสำหรับเก็บชิ้นส่วนชั่วคราว

function esc(s) {
  return String(s)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

function escAttr(s) {
  return esc(s).replace(/'/g, '&#39;');
}

/* จัดรูปแบบข้อความในบรรทัด (ไม่มี placeholder) */
function fmtInline(s) {
  let t = esc(s);
  t = t.replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>');
  t = t.replace(/__([^_]+)__/g, '<strong>$1</strong>');
  t = t.replace(/(^|[^\w*])\*([^*\n]+)\*(?!\w)/g, '$1<em>$2</em>');
  t = t.replace(/~~([^~]+)~~/g, '<del>$1</del>');
  t = t.replace(/==([^=]+)==/g, '<mark>$1</mark>');
  return t;
}

const CALLOUTS = [
  { re: /^(?:<strong>)?\s*🛠️/, cls: 'todo', title: '' },
  { re: /^(?:<strong>)?\s*🎯/, cls: 'exercise', title: '' },
  { re: /^(?:<strong>)?\s*⚠️/, cls: 'warn', title: '' },
  { re: /^(?:<strong>)?\s*💡/, cls: 'tip', title: '' },
  { re: /^(?:<strong>)?\s*📌/, cls: 'tip', title: '' },
];

export function renderMarkdown(src) {
  const store = [];
  const keep = (obj) => PH + (store.push(obj) - 1) + PH;

  let text = String(src ?? '')
    .replace(/\r\n?/g, '\n')
    .replace(/\t/g, '    ')
    // front matter (--- ... ---) ที่ต้นไฟล์
    .replace(/^---\n[\s\S]*?\n---\n/, '');

  // 1) code fence
  text = text.replace(/^ {0,3}```([^\n`]*)\n([\s\S]*?)^ {0,3}```[ \t]*$/gm, (_m, info, code) => {
    const lang = (info || '').trim().split(/[\s{]/)[0].toLowerCase();
    return keep({ t: 'code', lang, code });
  });

  // 2) inline code
  text = text.replace(/`([^`\n]+)`/g, (_m, code) => keep({ t: 'icode', code }));

  // 3) รูปภาพ แล้วลิงก์
  text = text.replace(/!\[([^\]]*)\]\(([^)\s]+)\)/g, (_m, alt, href) => keep({ t: 'img', alt, href }));
  text = text.replace(/\[([^\]]+)\]\(([^)\s]+)\)/g, (_m, label, href) => keep({ t: 'link', label, href }));

  const rendered = renderBlocks(text.split('\n'));

  // คืนค่า placeholder ทั้งหมด
  return rendered.replace(new RegExp(PH + '(\\d+)' + PH, 'g'), (_m, n) => {
    const it = store[Number(n)];
    if (!it) return '';
    if (it.t === 'code') {
      if (it.lang === 'mermaid') {
        return `<div class="mermaid">${esc(it.code)}</div>`;
      }
      return `<pre data-lang="${escAttr(it.lang || 'text')}"><code>${esc(it.code)}</code></pre>`;
    }
    if (it.t === 'icode') return `<code>${esc(it.code)}</code>`;
    if (it.t === 'img') return `<img src="${escAttr(it.href)}" alt="${escAttr(it.alt)}" loading="lazy">`;
    if (it.t === 'link') return `<a href="${escAttr(it.href)}">${fmtInline(it.label)}</a>`;
    return '';
  });
}

/* ---------- block level ---------- */

const RE_HEAD = /^(#{1,6})\s+(.*?)\s*#*\s*$/;
const RE_HR = /^\s{0,3}(?:-{3,}|\*{3,}|_{3,})\s*$/;
const RE_ITEM = /^(\s*)([-*+]|\d+[.)])\s+(.*)$/;
const RE_QUOTE = /^\s{0,3}>\s?/;
const RE_ONLY_PH = new RegExp('^' + PH + '\\d+' + PH + '$');

function indentOf(line) {
  const m = line.match(/^(\s*)/);
  return m ? m[1].length : 0;
}

function splitRow(line) {
  let s = line.trim();
  if (s.startsWith('|')) s = s.slice(1);
  if (s.endsWith('|')) s = s.slice(0, -1);
  return s.split('|').map((c) => c.trim());
}

function isTableSeparator(line) {
  return (
    typeof line === 'string' &&
    line.includes('|') &&
    /^\s*\|?\s*:?-{2,}:?\s*(\|\s*:?-{2,}:?\s*)*\|?\s*$/.test(line)
  );
}

function startsBlock(line) {
  return (
    RE_HEAD.test(line) ||
    RE_HR.test(line) ||
    RE_ITEM.test(line) ||
    RE_QUOTE.test(line) ||
    RE_ONLY_PH.test(line.trim()) ||
    line.trimStart().startsWith('|')
  );
}

function renderBlocks(lines) {
  const out = [];
  let i = 0;

  while (i < lines.length) {
    const line = lines[i];

    if (!line.trim()) { i++; continue; }

    // heading
    let m = line.match(RE_HEAD);
    if (m) {
      const lvl = m[1].length;
      out.push(`<h${lvl}>${fmtInline(m[2])}</h${lvl}>`);
      i++;
      continue;
    }

    // hr
    if (RE_HR.test(line)) { out.push('<hr>'); i++; continue; }

    // code block placeholder (เดี่ยวๆ)
    if (RE_ONLY_PH.test(line.trim())) { out.push(line.trim()); i++; continue; }

    // table
    if (line.trimStart().startsWith('|') && isTableSeparator(lines[i + 1] || '')) {
      const head = splitRow(line);
      const aligns = splitRow(lines[i + 1]).map((c) => {
        const l = c.startsWith(':');
        const r = c.endsWith(':');
        return l && r ? 'center' : r ? 'right' : l ? 'left' : '';
      });
      i += 2;
      const rows = [];
      while (i < lines.length && lines[i].trimStart().startsWith('|')) {
        rows.push(splitRow(lines[i]));
        i++;
      }
      let html = '<table><thead><tr>';
      head.forEach((c, idx) => {
        html += `<th${aligns[idx] ? ` style="text-align:${aligns[idx]}"` : ''}>${fmtInline(c)}</th>`;
      });
      html += '</tr></thead><tbody>';
      for (const r of rows) {
        html += '<tr>';
        for (let c = 0; c < head.length; c++) {
          html += `<td${aligns[c] ? ` style="text-align:${aligns[c]}"` : ''}>${fmtInline(r[c] ?? '')}</td>`;
        }
        html += '</tr>';
      }
      html += '</tbody></table>';
      out.push(html);
      continue;
    }

    // blockquote → callout
    if (RE_QUOTE.test(line)) {
      const buf = [];
      while (i < lines.length) {
        if (RE_QUOTE.test(lines[i])) { buf.push(lines[i].replace(RE_QUOTE, '')); i++; continue; }
        if (!lines[i].trim() && i + 1 < lines.length && RE_QUOTE.test(lines[i + 1])) { buf.push(''); i++; continue; }
        break;
      }
      const inner = renderMarkdownStripped(buf.join('\n'));
      const head = buf.find((l) => l.trim()) || '';
      const cls = CALLOUTS.find((c) => c.re.test(head.trim()));
      out.push(
        cls
          ? `<div class="callout ${cls.cls}">${inner}</div>`
          : `<blockquote>${inner}</blockquote>`
      );
      continue;
    }

    // list
    if (RE_ITEM.test(line)) {
      const res = parseList(lines, i);
      out.push(res.html);
      i = res.next;
      continue;
    }

    // paragraph
    const para = [];
    while (i < lines.length && lines[i].trim() && !startsBlock(lines[i])) {
      para.push(lines[i]);
      i++;
    }
    if (para.length) out.push(`<p>${para.map((l) => fmtInline(l)).join('<br>')}</p>`);
  }

  return out.join('\n');
}

/* ใช้กับเนื้อหาใน blockquote: แปลงโดยไม่ต้องแยก placeholder ใหม่ */
function renderMarkdownStripped(src) {
  return renderMarkdown(src);
}

function parseList(lines, start) {
  const firstIndent = indentOf(lines[start]);
  const ordered = /^\s*\d+[.)]\s+/.test(lines[start]);
  const items = [];
  let cur = null;
  let i = start;

  while (i < lines.length) {
    const line = lines[i];

    if (!line.trim()) {
      let j = i + 1;
      while (j < lines.length && !lines[j].trim()) j++;
      if (j < lines.length && RE_ITEM.test(lines[j]) && indentOf(lines[j]) >= firstIndent) {
        i = j;
        continue;
      }
      break;
    }

    const m = line.match(RE_ITEM);
    if (!m) {
      if (cur && !startsBlock(line)) {
        cur.text += '<br>' + fmtInline(line.trim());
        i++;
        continue;
      }
      break;
    }

    const indent = m[1].length;
    if (indent < firstIndent) break;

    if (indent > firstIndent && cur) {
      const sub = parseList(lines, i);
      cur.children.push(sub.html);
      i = sub.next;
      continue;
    }

    let content = m[3];
    let task = null;
    const tm = content.match(/^\[([ xX])\]\s*(.*)$/);
    if (tm) { task = tm[1].toLowerCase() === 'x'; content = tm[2]; }

    cur = { text: fmtInline(content), children: [], task };
    items.push(cur);
    i++;
  }

  let html = ordered ? '<ol>' : '<ul>';
  for (const it of items) {
    if (it.task !== null) {
      html += `<li class="task"><input type="checkbox" disabled${it.task ? ' checked' : ''}><span>${it.text}${it.children.join('')}</span></li>`;
    } else {
      html += `<li>${it.text}${it.children.join('')}</li>`;
    }
  }
  html += ordered ? '</ol>' : '</ul>';
  return { html, next: i };
}
