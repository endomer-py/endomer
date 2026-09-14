"""Extract the final ZIP, verify all hashes, then install it in a fresh R library."""
from pathlib import Path
import hashlib,json,os,subprocess,sys,zipfile
root=Path(__file__).resolve().parents[2]
out=Path(os.environ.get('ENDOMER_RELEASE_DIR',root/'artifacts/endomer-engih-release')).resolve()
assert out.is_relative_to(root) and out!=root and not out.is_relative_to(root/'endomer')
report=json.loads((out/'delivery-audit.json').read_text(encoding='utf-8'))
archive=out/report['archive'];extracted=out/'zip-extracted'
assert not extracted.exists() and not (out/'install-zip').exists(),'Choose a new output directory for fresh extraction/installation'
assert hashlib.sha256(archive.read_bytes()).hexdigest()==report['sha256']
with zipfile.ZipFile(archive) as z:
    for info in z.infolist():
        assert (extracted/info.filename).resolve().is_relative_to(extracted)
    z.extractall(extracted)
manifest=json.loads((extracted/'SHA256SUMS.json').read_text(encoding='utf-8'))
assert {p.relative_to(extracted).as_posix() for p in extracted.rglob('*') if p.is_file()}==set(manifest)|{'SHA256SUMS.json'}
for name,digest in manifest.items():assert hashlib.sha256((extracted/name).read_bytes()).hexdigest()==digest,name
rscript=sys.argv[1] if len(sys.argv)>1 else 'Rscript'
env=os.environ.copy();env['LC_ALL']='English_United States.utf8' if os.name=='nt' else env.get('LC_ALL','C.UTF-8')
env['RENV_CONFIG_AUTOLOADER_ENABLED']='false';env['ENDOMER_RELEASE_DIR']=str(out)
with (out/'zip-install.log').open('w',encoding='utf-8') as log:
    subprocess.run([rscript,str(root/'endomer/scripts/verify-extracted.R')],cwd=root,env=env,stdout=log,stderr=subprocess.STDOUT,check=True)
installed=json.loads((out/'integration-zip-audit.json').read_text(encoding='utf-8'))
assert installed['success'] and len(installed['resolved_libraries'])==7
result={'archive':archive.name,'sha256':report['sha256'],'extracted_files_verified':len(manifest),
 'installed_from_extracted_bundle':True,'namespaces':installed['resolved_libraries'],
 'tests':installed['tests'],'executed_guides':len(installed['executed_guides'])}
(out/'zip-install-audit.json').write_text(json.dumps(result,indent=2),encoding='utf-8')
print(json.dumps(result,indent=2))
