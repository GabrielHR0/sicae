const fs = require('fs');
const fname = process.argv[2];
if(!fname){
  console.error('Usage: node check_html_tags.js <file>');
  process.exit(2);
}
const s = fs.readFileSync(fname,'utf8');
const voidTags = new Set(['area','base','br','col','embed','hr','img','input','link','meta','source','track','wbr']);
const stack = [];
const issues = [];
const re = /<%[\s\S]*?%>|<!--([\s\S]*?)-->|<\s*(\/)?\s*([a-zA-Z0-9:-]+)([^>]*)>/g;
let m;
while((m = re.exec(s)) !== null){
  if(m[0].startsWith('<%')) continue; // ERB
  if(m[0].startsWith('<!--')) continue; // comment
  const isClose = !!m[1] || !!m[2] && m[1]===undefined && /^\//.test(m[0]);
  // regex groups: m[1] comment, m[2] maybe undefined, but we used different grouping; adjust
  // Actually groups: m[1] from comment, m[2] is the closing slash capture? But above pattern set group1 for ERB? To be safe, parse manually
}
// Simpler second pass: manual regex for tags
const tagRe = /<\s*(\/)?\s*([a-zA-Z0-9:-]+)([^>]*)>/g;
while((m = tagRe.exec(s))!==null){
  const slash = m[1];
  const name = m[2].toLowerCase();
  const rest = m[3] || '';
  // skip if inside comment or ERB - naive: check if there is <!-- before this tag and --> after without closing in between
  // Simpler: ignore tags that start with ! (doctype)
  if(name.startsWith('!')) continue;
  // self-closing
  const selfClose = /\/\s*>$/.test(m[0]) || /\/\s*$/.test(rest) || rest.trim().endsWith('/');
  if(slash){
    // closing
    if(stack.length===0){
      issues.push({type:'unexpected-closing', tag:name, pos:m.index});
    } else {
      const top = stack.pop();
      if(top.tag !== name){
        issues.push({type:'mismatch', expected:top.tag, found:name, pos:m.index});
      }
    }
  } else if(!selfClose && !voidTags.has(name)){
    // opening
    stack.push({tag:name, pos:m.index});
  }
}
if(stack.length>0){
  stack.forEach(item=>issues.push({type:'unclosed', tag:item.tag, pos:item.pos}));
}
if(issues.length===0){
  console.log('No tag issues found');
  process.exit(0);
}
function lineAt(pos){
  return s.slice(0,pos).split('\n').length;
}
console.log('Found issues:');
issues.forEach(it=>{
  if(it.type==='unexpected-closing') console.log(`Unexpected closing tag </${it.tag}> at line ${lineAt(it.pos)}`);
  else if(it.type==='mismatch') console.log(`Tag mismatch at line ${lineAt(it.pos)}: expected </${it.expected}>, found </${it.found}>`);
  else if(it.type==='unclosed') console.log(`Unclosed tag <${it.tag}> opened at line ${lineAt(it.pos)}`);
});
process.exit(1);
