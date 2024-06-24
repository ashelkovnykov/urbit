function __vite__mapDeps(indexes) {
  if (!__vite__mapDeps.viteFileDeps) {
    __vite__mapDeps.viteFileDeps = ["memory.js","index.js","index.css"]
  }
  return indexes.map((i) => __vite__mapDeps.viteFileDeps[i])
}
import{_ as l}from"./index.js";const E={INVALID:["seeking position failed.","InvalidStateError"],GONE:["A requested file or directory could not be found at the time an operation was processed.","NotFoundError"],MISMATCH:["The path supplied exists, but was not an entry of requested type.","TypeMismatchError"],MOD_ERR:["The object can not be modified in this way.","InvalidModificationError"],SYNTAX:e=>[`Failed to execute 'write' on 'UnderlyingSinkBase': Invalid params passed. ${e}`,"SyntaxError"],ABORT:["The operation was aborted","AbortError"],SECURITY:["It was determined that certain files are unsafe for access within a Web application, or that too many calls are being made on file resources.","SecurityError"],DISALLOWED:["The request is not allowed by the user agent or the platform in the current context.","NotAllowedError"]},y=e=>typeof e=="object"&&typeof e.type<"u";async function v(e){var o,r,a;const{FolderHandle:t,FileHandle:u}=await l(()=>import("./memory.js"),__vite__mapDeps([0,1,2])),{FileSystemDirectoryHandle:m}=await l(()=>import("./index.js").then(n=>n.a),__vite__mapDeps([1,2])),p=(r=(o=e[0].webkitRelativePath)===null||o===void 0?void 0:o.split("/",1)[0])!==null&&r!==void 0?r:"",_=new t(p,!1);for(let n=0;n<e.length;n++){const i=e[n],d=!((a=i.webkitRelativePath)===null||a===void 0)&&a.length?i.webkitRelativePath.split("/"):["",i.name];d.shift();const f=d.pop(),w=d.reduce((c,s)=>(c._entries[s]||(c._entries[s]=new t(s,!1)),c._entries[s]),_);w._entries[f]=new u(i.name,i,!1)}return new m(_)}async function b(e){const{FileHandle:o}=await l(()=>import("./memory.js"),__vite__mapDeps([0,1,2])),{FileSystemFileHandle:r}=await l(()=>import("./index.js").then(t=>t.F),__vite__mapDeps([1,2]));return Array.from(e).map(t=>new r(new o(t.name,t,!1)))}export{E as errors,y as isChunkObject,v as makeDirHandleFromFileList,b as makeFileHandlesFromFileList};